#!/bin/bash

# fail if anything fails
set -e

source common.sh

live_data "mainnet-16"  "https://storage.googleapis.com/flow-genesis-bootstrap/mainnet-16-execution" "cd74783d55edf34aecbe6f4d423cb4cba8e9b06bc0c6be057d3a38007df18873"

/usr/bin/supervisord -c /supervisord.conf