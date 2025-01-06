#!/bin/bash

# Helper function to display usage instructions
docker-acme-helper() {
  echo "Usage: docker-action <container_id> <action>"
  echo "  <container_id>: Container ID or name. For multiple containers, separate them with commas (e.g., container1,container2)."
  echo "  <action>: Action to perform on the container(s) (e.g., start, stop, restart, pause, unpause)."
  echo "Example:"
  echo "  docker-action my_container_id start"
  echo "  docker-action container1,container2 stop"
}

# Function to perform Docker actions
docker-action() {
  local CONTAINER_ID=$1
  local ACTION=$2
  local DOCKER_HOST=${DOCKER_HOST:-"/var/run/docker.sock"}

  # Validate inputs
  if [ -z "$CONTAINER_ID" ] || [ -z "$ACTION" ]; then
    echo "Error: Missing container ID or action."
    docker-acme-helper
    return 1
  fi

  # Iterate over comma-separated container IDs
  IFS=',' read -ra CONTAINER_IDS <<< "$CONTAINER_ID"
  for id in "${CONTAINER_IDS[@]}"; do
    # Validate action by checking Docker API compatibility
    case "$ACTION" in
      start|stop|restart|pause|unpause)
        ;;
      *)
        echo "Error: Invalid action '$ACTION'. Supported actions are: start, stop, restart, pause, unpause."
        return 1
        ;;
    esac

    # Perform the Docker action using curl
    response=$(curl --silent --write-out "%{http_code}" --output /dev/null --unix-socket "$DOCKER_HOST" \
      -X POST "http://localhost/containers/$id/$ACTION")

    # Check the response status code
    if [ "$response" -eq 204 ]; then
      echo "Success: $ACTION action performed on container '$id'."
    elif [ "$response" -eq 404 ]; then
      echo "Error: Container '$id' not found."
    elif [ "$response" -eq 409 ]; then
      echo "Error: Conflict while performing '$ACTION' on container '$id' (e.g., already stopped)."
    else
      echo "Error: Failed to perform '$ACTION' on container '$id'. HTTP status code: $response"
    fi
  done
}

# Example usage
# docker-action "proxy" "start"
# docker-action "container1,container2" "stop"
# docker-action "my_container_id" "restart"