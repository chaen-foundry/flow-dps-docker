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

# Override address for mainnet16 since sporks.json has the wrong port
SEED_ADDRESS="access-007.mainnet16.nodes.onflow.org:3570"

/usr/bin/supervisord -c /supervisord.conf