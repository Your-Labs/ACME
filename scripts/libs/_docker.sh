#!/bin/bash
force_load=${1:-0}
# ---------------------------------------------------------------
# check if the file is loaded(source) already
if [ -n "$_MYACME_LIBS_DOCKER_LOADED" ] && [ "$force_load" != "--force" ]; then
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
# echo "MYACME_LIBS_DIR: $MYACME_LIBS_DIR"
EXEC_LOG_SOURCE_SH="$MYACME_LIBS_DIR/_exec_log.sh"
[[ -f "$EXEC_LOG_SOURCE_SH" ]] && source "$EXEC_LOG_SOURCE_SH" $force_load
ROOT=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
# ---------------------------------------------------------------

# Helper function to display usage instructions
docker-helper() {
  echo "Usage: docker_ <action> <container_id>"
  echo "  <action>: Action to perform on the container(s) (e.g., start, stop, restart, pause, unpause)."
  echo "  <container_id>: Container ID or name. For multiple containers, separate them with commas (e.g., container1,container2)."
  echo "Example:"
  echo "  docker_ start my_container_id"
  echo "  docker_ stop container1,container2"
}

# Function to perform Docker actions
docker_() {
  local action=$1
  local container_id=$2
  local docker_sock=${3:-"/var/run/docker.sock"}
  local dry_run=${4:-0}

  # Validate inputs
  if [ -z "$container_id" ] || [ -z "$action" ]; then
    echo "Error: Missing container ID or action."
    docker-helper
    return 1
  fi

  # Iterate over comma-separated container IDs
  IFS=',' read -ra container_ids <<<"$container_id"
  for id in "${container_ids[@]}"; do
    # Validate action by checking Docker API compatibility
    case "$action" in
    start | stop | restart | pause | unpause) ;;
    *)
      mylog "error" "Invalid action '$action'. Supported actions are: start, stop, restart, pause, unpause."
      return 1
      ;;
    esac

    # Perform the Docker action using curl
    if [ "$dry_run" = "1" ] || [ "$dry_run" == "true" ]; then
      mylog "info" "[Dry Run] Performing '$action' action on container '$id'..."
      continue
    fi
    mylog "info" "Performing '$action' action on container '$id'..."
    # Perform the Docker action using curl
    response=$(curl --silent --write-out "%{http_code}" --output /dev/null --unix-socket "$DOCKER_HOST" \
      -X POST "http://localhost/containers/$id/$ACTION")

    # Check the response status code
    if [ "$response" -eq 204 ]; then
      mylog "info" "Success: $action action performed on container '$id'."
    elif [ "$response" -eq 404 ]; then
      mylog "error" "Error: Container '$id' not found."
    elif [ "$response" -eq 409 ]; then
      mylog "error" "Error: Conflict while performing '$action' on container '$id' (e.g., already stopped)."
    else
      mylog "error" "Error: Failed to perform '$action' on container '$id'. HTTP status code: $response"
    fi
  done
}
# Example usage
# docker_ "start" "proxy"
# docker_ "stop" "container1,container2"
# docker_ "restart" "container1,container2" "/var/run/docker.sock"

# Function to perform Docker actions via Unix socket
docker_exec() {
  local container_ids="$1"                         # Comma-separated container IDs
  local command="$2"                               # Command to execute in the container
  local docker_sock="${3:-"/var/run/docker.sock"}" # Docker socket path (default: /var/run/docker.sock)
  local dry_run="${4:-0}"                          # Dry-run flag (default: 0)
  # Validate inputs
  if [ -z "$container_ids" ] || [ -z "$command" ]; then
    mylog "error" "Missing container ID or command."
    mylog "error" "Usage: docker_exec <container_id> <command>"
    return 1
  fi

  # Split comma-separated container IDs into an array
  IFS=',' read -ra ids <<<"$container_ids"

  # Iterate over each container ID
  for container_id in "${ids[@]}"; do
    mylog "info" "Executing command in container '$container_id'..."

    if [ "$dry_run" = "1" ] || [ "$dry_run" == "true" ]; then
      mylog "info" "[Dry Run] Executing command to container '$container_id': $command"
      continue
    fi

    # Step 1: Create exec instance
    exec_id=$(curl -s --unix-socket "$docker_sock" -X POST \
      -H "Content-Type: application/json" \
      -d "{
            \"AttachStdin\": false,
            \"AttachStdout\": true,
            \"AttachStderr\": true,
            \"Tty\": false,
            \"Cmd\": [\"/bin/sh\", \"-c\", \"$command\"]
          }" \
      "http://localhost/containers/$container_id/exec" | jq -r '.Id')

    # Check if exec ID was created successfully
    if [ -z "$exec_id" ] || [ "$exec_id" == "null" ]; then
      echo "Error: Failed to create exec instance for container '$container_id'."
      continue
    fi

    # Step 2: Start exec instance
    response=$(curl -s --unix-socket "$docker_sock" -X POST \
      -H "Content-Type: application/json" \
      -d '{
            "Detach": false,
            "Tty": false
          }' \
      "http://localhost/exec/$exec_id/start")

    # Check if the command executed successfully
    if [ -n "$response" ]; then
      echo "Output from container '$container_id':"
      echo "$response"
    else
      echo "Error: Failed to execute command in container '$container_id'."
    fi
  done
}

# ---------------------------------------------------------------
# Mark the file as loaded
export _MYACME_LIBS_DOCKER_LOADED=1
# ---------------------------------------------------------------
