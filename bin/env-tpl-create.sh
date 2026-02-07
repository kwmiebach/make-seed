#!/bin/bash

# env-tpl-create.sh
# Creates .env-tpl from .env file with sensitive values masked
#
# This script reads the .env file and creates a safe template file
# that can be committed to version control. Any line containing
# PASSWORD, TOKEN, SECRET, or KEY will have its value replaced with *****

set -e

ENV_FILE=".env"
TPL_FILE=".env-tpl"

# Check if .env exists
if [[ ! -f "$ENV_FILE" ]]; then
    echo "Error: $ENV_FILE not found"
    echo "Please create a .env file first"
    exit 1
fi

if [[ ! -s "$ENV_FILE" ]]; then
    echo "Error: $ENV_FILE is empty"
    exit 1
fi

echo "Creating $TPL_FILE from $ENV_FILE..."

# Use awk to process the .env file
awk -F '=' '
{
    # Skip empty lines and comments
    if (NF == 0 || $0 ~ /^[[:space:]]*#/) {
        print $0
        next
    }

    # If the line contains sensitive keywords
    if ($1 ~ /PASSWORD|TOKEN|SECRET|KEY/) {
        # Replace the value with *****
        print $1 "=*****"
    } else {
        # Otherwise, print the line as is
        print $0
    }
}' "$ENV_FILE" > "$TPL_FILE"

echo "✓ Created $TPL_FILE"
echo ""
echo "The following sensitive variables were masked:"
grep -E 'PASSWORD|TOKEN|SECRET|KEY' "$ENV_FILE" | cut -d'=' -f1 || echo "  (none found)"
echo ""
echo "You can now safely commit $TPL_FILE to version control"
