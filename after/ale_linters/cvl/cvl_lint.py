"""
Syntax check for ALE vim plugin
===============================

For how to add a linter, see ``:help ale#linter#Define()``.
For where to place files and more, see ``:help ale-lint``.

.. note::

    This assumes mod:`certora-cli` is installed.
"""
import json
import subprocess
import sys
from argparse import ArgumentParser
from collections.abc import Sequence
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
from typing import List, Optional, Tuple

# ==============================================================================
# const
# ==============================================================================
CONTRACT_PRAGMA = "// #contract"
# TODO: also enable compiler override in spec file, eg "// #solc 5.12"


# ==============================================================================
# utils
# ==============================================================================
class ContractPath:
    """
    Represents a path to a solidity file and a contract in said file.
    """

    def __init__(self, path: Path, contract: str):
        self._path = path
        self._contract = contract

    @property
    def contract(self) -> str:
        return self._contract

    def path(self, spec_path: Optional[Path] = None) -> Path:
        if self._path.is_absolute():
            return self._path

        # Check for `~`
        expanded = self._path.expanduser()
        if expanded.is_absolute():
            return expanded

        # Path is relative to spec_path
        if spec_path is None:
            raise ValueError(
                f"contract path {self._path} is relative, must supply spec path"
            )
        spec_dir = spec_path if spec_path.is_dir() else spec_path.parent
        path = spec_dir / self._path
        if not path.exists():
            raise IOError(f"contract path {path} not found!")
        return path

    def to_string(self, spec_path: Optional[Path] = None) -> str:
        return f"{self.path(spec_path)}:{self.contract}"

    @classmethod
    def from_str(cls, contract_desc: str) -> "ContractPath":
        if contract_desc.count(":") != 1:
            raise ValueError("contract string must contain one colon")
        path_str, contract_name = contract_desc.split(":")
        return cls(Path(path_str), contract_name)

    @classmethod
    def from_spec(cls, spec: str) -> "ContractPath":
        first_line = spec.splitlines()[0]
        if not first_line.startswith(CONTRACT_PRAGMA):
            return None

        contract_desc = first_line[len(CONTRACT_PRAGMA) :].strip()
        return cls.from_str(contract_desc)


# ==============================================================================
# errors data
# ==============================================================================
@dataclass
class ErrorMessage:
    row: Optional[int]
    column: Optional[int]
    message: str

    def to_ale_dict(self) -> dict:
        """
        :returns: a dictionary in a form acceptable by ale vim plugin
        """
        lnum = self.row if self.row is not None else 0
        col = self.column if self.column is not None else 0
        text = self.message
        return dict(lnum=lnum, col=col, text=text)

    def __str__(self) -> str:
        lnum = self.row if self.row is not None else 0
        col = self.column if self.column is not None else 0
        text = self.message
        return f"{lnum}:{col}:{text}"

    @classmethod
    def from_dict(cls, data: dict) -> "ErrorMessage":
        raw = data["message"]
        parts = raw.split(":")
        message = ":".join(parts[-2:])
        try:
            row = int(parts[1])
        except ValueError:
            # Could be "?" if there is no line
            row = None

        try:
            column = int(parts[2])
        except ValueError:
            # Could be missing completely
            column = None

        return cls(row, column, message)


class ErrorMessages(Sequence):  # Sequence[ErrorMessage]
    _TOPIC_NAME = "type_check"

    def __init__(self, errors: List[ErrorMessage]):
        self._errors = errors

    def __len__(self) -> int:
        return len(self._errors)

    def __getitem__(self, index: int) -> ErrorMessage:
        return self._errors[index]

    def sort(self):
        """
        Sort by (row, column) giving precedence to None values.
        """

        def sort_key(err: ErrorMessage) -> Tuple[int, int]:
            row = -1 if err.row is None else err.row
            col = -1 if err.column is None else err.column
            return (row, col)

        self._errors = sorted(self._errors, key=sort_key)

    def to_ale_dicts(self) -> List[dict]:
        """
        :returns: a list of dictionaries in a form acceptable by ale vim plugin
        """
        return [err.to_ale_dict for err in self._errors]

    @classmethod
    def from_json_file(cls, path: Path) -> "ErrorMessage":
        raw_dict = json.load(open(path))
        topics = raw_dict.get("topics", [])
        try:
            topic = next(t for t in topics if t.get("name") == cls._TOPIC_NAME)
        except StopIteration:
            # No errors
            return cls([])

        messages = topic.get("messages", [])
        errors = [ErrorMessage.from_dict(err_dict) for err_dict in messages]
        return cls(errors)


# ==============================================================================
# cvl linter
# ==============================================================================
class CVLLinter:
    # certoraRun command
    _CMD = "certoraRun"
    _VERIFY_OPTION = "--verify"
    _TYPECHECK_OPTION = "--typecheck_only"
    _SOLIDITY_OPTION = "--solc"
    _COMPILER_PREFIX = "solc"

    # Compiler version
    _SOLIDITY_PRAGMA = "pragma solidity"

    # Return data
    _DIRNAME = ".certora_internal"
    _TIME_PREFIX_FORMAT = "%y_%m_%d_%H_%M_%S"
    _ERRORS_FILE = "resource_errors.json"

    def __init__(self, spec_path: Path):
        self._spec_path = spec_path
        self._spec_cache = None  # Caching the spec
        self._cached_contract_path = None

    @property
    def _contract_path(self) -> ContractPath:
        if self._cached_contract_path is not None:
            return self._cached_contract_path
        self._cached_contract_path = ContractPath.from_spec(self._spec)
        return self._cached_contract_path

    @property
    def _solidity_path(self) -> str:
        return self._contract_path.path(self._spec_path)

    @property
    def _working_dir(self) -> Path:
        # TODO: enable changing from default
        return self._spec_path.parent

    @property
    def _spec(self) -> str:
        """
        The spec file contents.
        """
        if self._spec_cache is not None:
            return self._spec_cache
        with open(self._spec_path) as spec_file:
            self._spec_cache = spec_file.read()
        return self._spec_cache

    @property
    def is_empty(self) -> bool:
        return self._spec_path is None

    def _get_compiler(self) -> str:
        with open(self._solidity_path) as sol:
            solidity = sol.read()

        try:
            line = next(
                line
                for line in solidity.splitlines()
                if line.startswith(self._SOLIDITY_PRAGMA)
            )
        except StopIteration:
            return ""

        data = line[len(self._SOLIDITY_PRAGMA) :].strip()
        start = data.index("0.") + len("0.")
        end = data.index(";")
        return f"{self._COMPILER_PREFIX}{data[start: end]}"

    def _gen_cmd_args(self) -> List[str]:
        contract_desc = self._contract_path.to_string(self._spec_path)
        contract_name = self._contract_path.contract

        args = [
            self._CMD,
            contract_desc,
            self._VERIFY_OPTION,
            f"{contract_name}:{self._spec_path}",
            self._TYPECHECK_OPTION,
        ]

        compiler = self._get_compiler()
        if compiler != "":
            args += [self._SOLIDITY_OPTION, compiler]
        return args

    def _get_results_dir(self, start_time: datetime) -> Path:
        time_prefix = start_time.strftime(self._TIME_PREFIX_FORMAT)
        cur_prefix = datetime.now().strftime(self._TIME_PREFIX_FORMAT)
        certora_dir = self._working_dir / self._DIRNAME
        possible_results_dir = [
            path
            for path in certora_dir.iterdir()
            if cur_prefix >= path.stem[: len(time_prefix)] >= time_prefix
        ]
        if len(possible_results_dir) == 0:
            raise RuntimeError(
                f"can't find results dir at {certora_dir} with prefix {time_prefix} "
                f"(start time {start_time})"
            )
        # Use the last one
        results_dir = max(possible_results_dir)
        return results_dir / self._ERRORS_FILE

    def run(self) -> int:
        if self.is_empty:  # Nothing to do
            return 0

        start_time = datetime.now()
        try:
            cmd_args = self._gen_cmd_args()
            result = subprocess.run(
                cmd_args, cwd=self._working_dir, capture_output=True
            )
        except FileNotFoundError:
            print(f"An error occurred while running command {cmd_args}")
            raise
        if result.returncode != 0:
            pass  # TODO: check return code?

        results_dir = self._get_results_dir(start_time)
        errors = ErrorMessages.from_json_file(results_dir)
        errors.sort()

        for err in errors:
            print(err)
        return 0

    @classmethod
    def _get_parser(cls) -> ArgumentParser:
        parser = ArgumentParser()
        # Allow running without argument
        parser.add_argument(
            "--spec-path", type=Path, default=None, help="cvl (.spec) file to use"
        )
        return parser

    @classmethod
    def from_args(cls) -> "CVLLinter":
        parser = cls._get_parser()
        args = parser.parse_args()
        return cls(args.spec_path)


if __name__ == "__main__":
    cvllinter = CVLLinter.from_args()
    sys.exit(cvllinter.run())
