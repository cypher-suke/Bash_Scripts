#!/bin/bash

# This script is used to ping a targeted IP address and check if it is reachable.
# It will ping any address that is passed as an argument.

script_name=${0}"
target=${1}

echo "Running ${script_name}..."
echo "Pinging: ${target}"
ping "${target}"