#!/bin/zsh

cd "$(dirname "$0")/.."

echo $0

if [[ -n "$CI" ]] || [[ $1 == "--fail-on-errors" ]] ; then
  FAIL_ON_ERRORS=true
  echo "Running in --fail-on-errors mode"
  ERROR_START=""
  COLOR_END=""
  INFO_START=""
else
  echo "Running in local mode"
  ERROR_START="\e[31m"
  COLOR_END="\e[0m"
  INFO_START="\e[34m"
fi

final_status=0
PODS_ROOT=${PODS_ROOT:-"Pods"}
PROJECT_DIR=${PROJECT_DIR:-$(pwd)}


function process() {
  echo "\n${INFO_START}# Running $1 #${COLOR_END}"
  local initial_git_diff=`git diff --no-color`
  local start=`date +%s`
  
  eval "$2"

  if [ "$FAIL_ON_ERRORS" = "true" ] && [[ "$initial_git_diff" != `git diff --no-color` ]]
  then
    echo "${ERROR_START}$1 generates git changes, run './Scripts/process.sh' and review the changes${COLOR_END}"
    final_status=1
  fi

  local end=`date +%s`
  echo Execution time was `expr $end - $start` seconds.
}

function process_output() {
  echo "\n${INFO_START}# Running $1 #${COLOR_END}"
  echo "$2"

  local start=`date +%s`
  
  local output=$(eval "$2")

  if [[ ! -z "$output" ]] then
    echo "${ERROR_START}$1 reports issues:\n-----\n$output\n-----\nrun './Scripts/process.sh' and fix them${COLOR_END}"
    
    if [ "$FAIL_ON_ERRORS" = "true" ] 
    then
      final_status=1
    fi
  fi

  local end=`date +%s`
  echo Execution time was `expr $end - $start` seconds.
}

# process_output "SwiftLint" "${PODS_ROOT}/SwiftLint/swiftlint lint --quiet"
process "SwiftFormat" "cd FireModules ; swift run swiftformat .; cd .."
process_output "SwiftLint" "FireModules/.build/arm64-apple-macosx/debug/swiftlint lint"
# process_output "SwiftLint" "swift run swiftlint"