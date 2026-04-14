#!/usr/bin/env bash

source "${BASH_SOURCE%/*}/helpers.sh"

# Pushd to data location on Windows
pushd /mnt/e/arr-stack

# Get all the stuff in /torrents
SEARCH_PATH="/torrents/tv"
TORRENTS_FOUND=()
for entry in "$SEARCH_PATH"/*; do
    TORRENTS_FOUND+=(${entry})
done

# Now look through each media folder
SEARCH_PATH="/media/tv"
MEDIA_FOUND=()
for entry in "$SEARCH_PATH"/*; do
    MEDIA_FOUND+=(${entry})
done
