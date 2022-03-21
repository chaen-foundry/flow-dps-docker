#!/bin/bash

# fail if anything fails
set -e

source common.sh

DATA_DIR="/data/mainnet-16"

# bootstrap function should set these variables
GCP_BUCKET=""
SEED_ADDRESS=""
SEED_KEY=""

bootstrap "mainnet" 16 "$DATA_DIR"

export GCP_BUCKET="$GCP_BUCKET"
export SEED_ADDRESS="access-007.mainnet16.nodes.onflow.org:3570" # "$SEED_ADDRESS" sporks.json is wrong currently
export SEED_KEY="$SEED_KEY"

/usr/bin/supervisord -c /supervisord.conf