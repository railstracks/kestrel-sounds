#!/bin/bash
# start_sonic_pi.sh — Start Sonic Pi 4.6 server headless for rendering
# Boots daemon, routes audio to null sink, saves ports for render.rb

SP_ROOT="${SP_ROOT:-/home/melvin/Development/sonic-pi/app}"
PORT_FILE="/tmp/sonic_pi_ports.txt"
SINK_NAME="sonic_pi_render"

# Kill existing
pkill -f "daemon.rb" 2>/dev/null || true
pkill -f "spider-server.rb" 2>/dev/null || true
pkill -f "scsynth.*-u" 2>/dev/null || true
sleep 2

# Create null sink
if ! pactl list short sinks 2>/dev/null | grep -q "$SINK_NAME"; then
    pactl load-module module-null-sink sink_name="$SINK_NAME" \
        sink_properties=device.description="Sonic_Pi_Render"
fi

# Boot daemon (handles pw-jack routing automatically)
QT_QPA_PLATFORM=offscreen ruby "$SP_ROOT/server/ruby/bin/daemon.rb" &
DAEMON_PID=$!
sleep 12

# Read port line from daemon stdout
# Format: daemon gui-listen gui-send scsynth osc-cues tau tau-phx token
# spider-server.rb ARGV[1] = gui-send = the port it LISTENS on for /run-code
PORT_LINE=$(head -1 /proc/$DAEMON_PID/fd/1 2>/dev/null)
[ -z "$PORT_LINE" ] && PORT_LINE=$(grep -m1 '^[0-9]' /proc/$DAEMON_PID/fd/1 2>/dev/null)

# Fallback: read from spider-server cmdline
if [ -z "$PORT_LINE" ]; then
    sleep 3
    SPIDER_PID=$(pgrep -f spider-server.rb)
    SPIDER_ARGS=$(cat /proc/$SPIDER_PID/cmdline | tr '\0' ' ')
    SPIDER_PORT=$(echo "$SPIDER_ARGS" | awk '{print $7}')
    SCSYNTH_PORT=$(echo "$SPIDER_ARGS" | awk '{print $9}')
    TOKEN=$(echo "$SPIDER_ARGS" | awk '{print $13}')
else
    read D GL GS SC OC T TP TOKEN <<< "$PORT_LINE"
    SPIDER_PORT=$GS
    SCSYNTH_PORT=$SC
fi

echo "$SPIDER_PID" > /tmp/sp_spider_pid.txt

cat > "$PORT_FILE" << EOF
SPIDER_PORT=$SPIDER_PORT
SCSYNTH_PORT=$SCSYNTH_PORT
TOKEN=$TOKEN
SINK_NAME=$SINK_NAME
EOF

# Route audio
pw-link -d "SuperCollider:out_1" "alsa_output.pci-0000_01_00.1.hdmi-stereo:playback_FL" 2>/dev/null || true
pw-link -d "SuperCollider:out_2" "alsa_output.pci-0000_01_00.1.hdmi-stereo:playback_FR" 2>/dev/null || true
pw-link "SuperCollider:out_1" "${SINK_NAME}:playback_FL"
pw-link "SuperCollider:out_2" "${SINK_NAME}:playback_FR"

echo "Sonic Pi 4.6 ready: spider=$SPIDER_PORT token=$TOKEN"
