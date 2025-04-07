#!/bin/bash

# Stealth TCP probe with randomized ports
# Usage: ./stealth_probe.sh <IP_or_Hostname>

TARGET="$1"
SCRIPT_NAME=$(basename "$0")
THROTTLE=3             # Delay between probes
PROBES=5               # How many randomized ports to try
LOOT_FILE="open_IPs.txt"

# Common ports - randomized selection
COMMON_PORTS=(22 53 80 443 8080 8443 110 143 21 3306 25 139 445 3389)

if [ -z "$TARGET" ]; then
    echo "Usage: $SCRIPT_NAME <IP_or_Hostname>"
    exit 1
fi

# Ask if Tor should be used (if available)
USE_TOR=0
if command -v torsocks >/dev/null 2>&1; then
    read -p "Tor detected. Route through Tor using torsocks? (y/N): " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        USE_TOR=1
        echo "[$SCRIPT_NAME] Using torsocks to route traffic through Tor..."
    fi
fi

# Header for loot file
echo "===== Probe Results: $(date) =====" >> "$LOOT_FILE"

echo "[$SCRIPT_NAME] Starting stealth probe of $TARGET..."

for ((i = 1; i <= PROBES; i++)); do
    PORT=${COMMON_PORTS[$RANDOM % ${#COMMON_PORTS[@]}]}
    echo "[$SCRIPT_NAME] Probing $TARGET on port $PORT..."

    CMD="timeout 3 bash -c '</dev/tcp/$TARGET/$PORT'"

    if [ "$USE_TOR" -eq 1 ]; then
        torsocks bash -c "$CMD" 2>/dev/null
    else
        eval "$CMD" 2>/dev/null
    fi

    if [ $? -eq 0 ]; then
        echo "[$SCRIPT_NAME] Host $TARGET responded on port $PORT 🎯"
        echo "$TARGET:$PORT" >> "$LOOT_FILE"
    else
        echo "[$SCRIPT_NAME] No response on port $PORT ❌"
    fi

    sleep "$THROTTLE"
done

echo "[$SCRIPT_NAME] Probe completed."
echo "[$SCRIPT_NAME] Results saved to: $LOOT_FILE"