#!/bin/bash

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "npm is not installed. Please install Node.js and npm."
    exit 1
else
    echo "npm is installed."
fi

# Check if ajv-formats is installed
if ! npm list -g ajv-formats &> /dev/null; then
    echo "ajv-formats is not installed. Installing..."
    npm install -g ajv-formats
else
    echo "ajv-formats is installed."
fi

# Check if ajv-cli is installed
if ! npm list -g ajv-cli &> /dev/null; then
    echo "ajv-cli is not installed. Installing..."
    npm install -g ajv-cli
else
    echo "ajv-cli is installed."
fi

# Check if a JSON schema file is provided as an argument
if [ -z "$1" ]; then
    echo "using default test schema at ./test_output/models_metaschema_schema.json"
    JSONSCHEMA_FILE="./test_output/models_metaschema_schema.json"
else
    JSONSCHEMA_FILE=$1
fi


# Validate the JSON schema
if [ -e "$JSONSCHEMA_FILE" ]; then
    echo "Compiling JSON schema to function: $JSONSCHEMA_FILE"
    ajv compile -s "$JSONSCHEMA_FILE" -c ajv-formats
    if [ $? -eq 0 ]; then
        echo "JSON schema is valid."
    else
        echo "JSON schema is invalid."
        exit 1
    fi
else
    echo "JSON schema file $JSONSCHEMA_FILE does not exist."
    exit 1
fi