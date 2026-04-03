#!/usr/bin/env bash

source "${BASH_SOURCE%/*}/helpers.sh"

pushd ..

# Run setup, just in case
./scripts/setup.sh

# Validate that container configs are populated

# Start the stack
docker compose up -d

# Return to where we were
popd
