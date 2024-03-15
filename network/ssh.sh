#!/bin/bash

# Path to the provided SSH keys file
PROVIDED_KEYS_FILE="/path/to/provided_keys.txt"

# Path to the authorized_keys file for a specific user
AUTHORIZED_KEYS_FILE="/home/username/.ssh/authorized_keys"

# Temporary file to store the new authorized_keys content
TEMP_AUTHORIZED_KEYS_FILE=$(mktemp)

# Ensure the temporary file is removed on script exit or interrupt
trap 'rm -f "$TEMP_AUTHORIZED_KEYS_FILE"' EXIT

# Check if the provided keys file exists
if [[ ! -f "$PROVIDED_KEYS_FILE" ]]; then
    echo "Provided SSH keys file not found: $PROVIDED_KEYS_FILE"
    exit 1
fi

# Check if the authorized_keys file exists
if [[ ! -f "$AUTHORIZED_KEYS_FILE" ]]; then
    echo "authorized_keys file not found: $AUTHORIZED_KEYS_FILE"
    exit 1
fi

# Iterate through each key in the authorized_keys file
while IFS= read -r authorized_key; do
    # Check if the current key is in the provided keys file
    if grep -qF "$authorized_key" "$PROVIDED_KEYS_FILE"; then
        # If the key is found, append it to the temporary authorized_keys file
        echo "$authorized_key" >> "$TEMP_AUTHORIZED_KEYS_FILE"
    else
        echo "Removing unauthorized key: $authorized_key"
    fi
done < "$AUTHORIZED_KEYS_FILE"

# Replace the authorized_keys file with the temporary file
mv "$TEMP_AUTHORIZED_KEYS_FILE" "$AUTHORIZED_KEYS_FILE"
