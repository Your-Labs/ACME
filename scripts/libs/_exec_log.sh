#!/bin/bash
force_load=${1:-0}
_is_main=$([[ -z $(caller 0) ]] && echo "true" || echo "false")
# ---------------------------------------------------------------
# check if the file is loaded(source) already
if [ -n "$_MYACME_LIBS_EXEC_LOG_LOADED" ] && [ "$force_load" != "--force" ]; then
  return 0
fi
# ---------------------------------------------------------------
# Pre Configuration
# If the MYACME_LIBS_DIR is not set, set it
if [ -z "$MYACME_LIBS_DIR" ]; then
  SOURCE_ROOT=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
  export MYACME_LIBS_DIR=$SOURCE_ROOT
  readonly MYACME_LIBS_DIR
fi
ROOT=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
# ---------------------------------------------------------------
# Color Definitions
# ---------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
RESET='\033[0m'

# ---------------------------------------------------------------
# Default Variables
# ---------------------------------------------------------------
DRY_RUN=0 # Default to not dry-run mode

# ---------------------------------------------------------------
# Function Definitions
# ---------------------------------------------------------------
# Function to print logs with colors
# Usage: mylog <level> <message>
#   level: Log level (info, success, warn, error, split)
#   message: Log message to display
mylog() {
  local level=$1
  local message=${2:-"========================================="} # 默认分隔线
  # local timestamp=$(date "+%Y-%m-%d %H:%M:%S")                    # 获取当前日期时间
  local timestamp=$(date)                    # 获取当前日期时间
  case "$level" in
  "info") echo -e "${CYAN}[$timestamp] [INFO] $message${RESET}" ;;
  "success") echo -e "${GREEN}[$timestamp] [SUCCESS] $message${RESET}" ;;
  "warn") echo -e "${YELLOW}[$timestamp] [WARNING] $message${RESET}" ;;
  "error") echo -e "${RED}[$timestamp] [ERROR] $message${RESET}" ;;
  "split") echo -e "${CYAN}$message${RESET}" ;; # 默认分隔线或自定义消息
  *) echo "[$timestamp] $message" ;;
  esac
}

# Function to execute a command with optional dry-run support
# Usage: execute_command <command> <description> <dry_run>
#   command: Command to execute (array or string)
#   description: Custom message to display while executing
#   dry_run: Flag to enable dry-run mode (0 or 1)
# Returns:
#   0: If the command is executed successfully
#   1: If the command execution fails
execute_command() {
  local description=${2:-"Executing command"}
  local dry_run=${3:-$DRY_RUN} # Use passed dry-run flag or default to global DRY_RUN

  # Check if the first argument is an array
  if declare -p "$1" 2>/dev/null | grep -q 'declare \-a'; then
    local -n cmd_array="$1" # Use nameref to refer to the array
    local cmd_string="${cmd_array[*]}"
  else
    local cmd_string="$1"
  fi

  # Dry-run mode
  if [ "$dry_run" = "1" ]; then
    mylog "info" "[Dry Run] $description: $cmd_string"
    return 0
  fi

  # Log and execute the command
  mylog "info" "$description"
  mylog "info" "Command: $cmd_string"
  eval "$cmd_string"

  # Capture the return value
  local r_value=$?
  if [ $r_value -eq 0 ]; then
    if [ -n "${cmd_array+x}" ]; then
      mylog "success" "Command succeeded: ${cmd_array[*]}"
    else
      mylog "success" "Command succeeded: $cmd_string"
    fi
    return 0
  else
    if [ -n "${cmd_array+x}" ]; then
      mylog "error" "Command failed: ${cmd_array[*]}"
    else
      mylog "error" "Command failed: $cmd_string"
    fi
    return $r_value
  fi
}
# ---------------------------------------------------------------
# Mark the file as loaded
export _MYACME_LIBS_EXEC_LOG_LOADED=1
# ---------------------------------------------------------------