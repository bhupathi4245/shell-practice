#!/bin/bash
#set -e

	# echo "hello set command"
	# echoooo "set will exit the script from the error - ie non zero status code"
	# however it will give the line number of error but will not give you the command that failed.
	# this can be handled with trap fuction.
	# echo "set command"

# Enable immediate exit on error
set -e

# Define the failure handling function
failure_handler() {
    echo "ERROR: Script failed on line $LINENO. Exit status: $?." >&2
    # Example cleanup: remove a temporary file
    if [ -f "/tmp/my_script_temp_$$" ]; then
        echo "Cleaning up temporary file: /tmp/my_script_temp_$$" >&2
        rm -f "/tmp/my_script_temp_$$"
    fi
    exit 1 # Exit the script with an error status
}

# Set the trap for the ERR signal
trap 'failure_handler' ERR