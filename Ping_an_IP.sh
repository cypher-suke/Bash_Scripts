#!/bin/bash

# This script pings a target IP address to check if it's reachable.
# Usage: ./ping_check.sh <IP_or_Hostname>

# Check for required argument
if [ -z "$1" ]; then
    echo "Usage: $0 <IP_or_Hostname>"
    exit 1
fi

target="$1"
script_name=$(basename "$0")

# Check if ping command is available
if ! command -v ping >/dev/null 2>&1; then
    echo "Error: 'ping' command not found on this system."
    exit 2
fi

echo "[$script_name] Pinging: $target"
ping -c 4 "$target"

# Exit code check
if [ $? -eq 0 ]; then
    echo "[$script_name] Success: $target is reachable."
else
    echo "[$script_name] Failure: $target is not reachable."
fi