#!/bin/bash

SECRET_FILE="$HOME/.secret/pass.txt"

# Hashed master password
MASTER_HASH="ea71c25a7a602246b4c39824b855678894a96f43bb9b71319c39700a1e045222"

# Prompt user for master password
read -s -p "Enter master password: " master_pass
echo

# Hash the input and compare
INPUT_HASH=$(echo -n "$master_pass" | sha256sum | awk '{print $1}')
if [[ "$INPUT_HASH" != "$MASTER_HASH" ]]; then
    echo "Incorrect master password. Exiting."
    exit 1
fi

# Read the real password/token from hidden file
if [[ -f "$SECRET_FILE" ]]; then
    REAL_PASS=$(<"$SECRET_FILE")
    export REAL_PASS
    echo "Master password accepted. Token unlocked."
else
    echo "Secret file not found!"
    exit 1
fi
