#!/bin/bash

# fail if anything fails
set -e

source common.sh

DATA_DIR="/data/mainnet-15"

export DATA_DIR="$DATA_DIR"

/usr/bin/supervisord -c /supervisord.conf