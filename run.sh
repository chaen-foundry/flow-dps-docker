#!/bin/bash

# fail if anything fails
set -e

source common.sh

DATA_DIR="/data/mainnet-16"
GCP_BUCKET=""
SEED_ADDRESS=""
SEED_KEY=""

bootstrap "mainnet" 16 "$DATA_DIR"

export DATA_DIR="$DATA_DIR"
export GCP_BUCKET="$GCP_BUCKET"
export SEED_ADDRESS="access-007.mainnet16.nodes.onflow.org:3570" # "$SEED_ADDRESS" sporks.json is wrong currently
export SEED_KEY="28a0d9edd0de3f15866dfe4aea1560c4504fe313fc6ca3f63a63e4f98d0e295144692a58ebe7f7894349198613f65b2d960abf99ec2625e247b1c78ba5bf2eae" # "$SEED_ADDRESS" sporks.json is wrong currently

/usr/bin/supervisord -c /supervisord.conf