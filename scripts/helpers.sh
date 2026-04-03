#!/usr/bin/env bash

# Log Helpers
info()  { echo "Info: $*"; }
warn()  { echo "Warn: $*"; }
ok()    { echo "Ok: $*"; }
error() { echo "Error: $*"; echo; exit 1; }
