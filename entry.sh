#!/usr/bin/env bash

set -e

# Descriptions
#   * Import SSH key to a file at local machine.
#   * Format: <cmd> ssh_id_file
#
# Input
#   * ssh_id_file {String}
#
# Environment Variables
#   * INPUT_KEY
function import_ssh_key {
    local ssh_id_file="$1"
    local ssh_dir=$(dirname "${ssh_id_file}")

    mkdir -vp "$ssh_dir"
    chmod 700 "$ssh_dir"
    echo "$INPUT_KEY" > "$ssh_id_file"
    chmod 600 "$ssh_id_file"
    echo "Immported SSH private key to $ssh_id_file"
}

# Descriptions
#   * Use SSH client to connect and execute commands at remote host.
#   * Format: <cmd> ssh_id_file host command_to_execute
#
# Input
#   * ssh_id_file {String} Path to SSH private key.
#   * host {String} Like `user@host`.
#   * command_to_execute {String} Command to execute, Bash syntax.
function execute_command {
    local ssh_id_file="$1"
    local host="$2"
    local command="$3"

    echo "Connecting to remote host..."
    ssh -i "$ssh_id_file" \
        -o UserKnownHostsFile=/dev/null \
        -o StrictHostKeyChecking=no \
        -t \
        "$host" "$command"
}

# Descriptions
#   * Execute commands at remote host.
#   * Format: <cmd> command_to_execute
#
# Environment Variables
#   * INPUT_HOST
#   * INPUT_KEY
function main {
    local host="$INPUT_HOST"
    local ssh_id_file="$HOME/ssh_action/id_rsa"
    local command="$1"

    if [[ -z "$host" ]]; then
        echo "ERROR: Environment variale INPUT_HOST is empty"
        exit 1
    fi

    if [[ -z "$INPUT_KEY" ]]; then
        echo "ERROR: Environment variale INPUT_KEY is empty"
        exit 1
    fi

    if [[ -z "$command" ]]; then
        echo "ERROR: Argument command is empty"
        exit 1
    fi

    import_ssh_key "$ssh_id_file"
    execute_command "$ssh_id_file" "$host" "$command"
}

main "$INPUT_COMMAND"
