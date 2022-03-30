#!/bin/bash

# fail if anything fails
set -e

source common.sh

DATA_DIR="/data/mainnet-15"

/usr/bin/supervisord -c /supervisord.conf