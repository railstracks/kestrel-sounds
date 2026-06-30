#!/bin/bash
# start_sonic_pi.sh — Start Sonic Pi server headless for rendering
# Creates null sink and routes SuperCollider output to it

# Kill any existing Sonic Pi processes
pkill -f "sonic-pi-server" 2>/dev/null || true
pkill -f "scsynth.*4556" 2>/dev/null || true
pkill -f "m2o.*Sonic" 2>/dev/null || true
pkill -f "o2m.*4563" 2>/dev/null || true
sleep 2

# Create null sink for recording
if ! pactl list short sinks 2>/dev/null | grep -q "sonic_pi_render"; then
    pactl load-module module-null-sink sink_name=sonic_pi_render \
        sink_properties=device.description="Sonic_Pi_Render"
    echo "Created null sink: sonic_pi_render"
fi

# Start Sonic Pi server headless
echo "Booting Sonic Pi server..."
QT_QPA_PLATFORM=offscreen PULSE_SINK=sonic_pi_render \
    /usr/lib/sonic-pi/app/server/ruby/bin/sonic-pi-server.rb &
SP_PID=$!

# Wait for boot
echo "Waiting for server to boot..."
sleep 12

# Route SuperCollider output to null sink
echo "Routing SuperCollider -> sonic_pi_render..."
pw-link -d "SuperCollider:out_1" "bluez_output.94_DB_56_18_A7_03.1:playback_FL" 2>/dev/null || true
pw-link -d "SuperCollider:out_2" "bluez_output.94_DB_56_18_A7_03.1:playback_FR" 2>/dev/null || true
pw-link "SuperCollider:out_1" "sonic_pi_render:playback_FL" 2>/dev/null
pw-link "SuperCollider:out_2" "sonic_pi_render:playback_FR" 2>/dev/null

echo ""
echo "Sonic Pi server ready (PID: $SP_PID)"
echo "Use: ruby render.rb <code_file> <output_wav> <duration>"