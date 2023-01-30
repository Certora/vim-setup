# vim-setup

Basic vim setup for using Certora Verification Language (CVL).
Provides basic syntax highlighting and primitive linting for CVL.

## Requirements
- Installed vim with Python3 support by running `vim --version` and checking the output contains `+python3`
- For linting, the [ALE vim plugin](https://github.com/dense-analysis/ale) is needed

For linting one **must specify the contract in the first line of the `.spec` file**, like so:

```
// #contract MeetingSchedulerFixed.sol:MeetingScheduler
```

The path to the solidity file can be relative to the `.spec` file.

## Installation
Clone the repository and either:

- copy the files to their respective folders under the `.vim\` directory, or
- add symlinks to the respective files/folders, for example:  
  `ln -s vim-setup/after/ale_linters ~/.vim/after/ale_linters`

## Caveats
1. The syntax highlighting is basic and missing many keywords
2. The linting is done by running `certoraRun ... --typecheck_only`, so it would fill
   the `.certota_internal` folder
3. The setup is hacky and apt to break
