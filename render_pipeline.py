#!/usr/bin/env python3
"""
Self-contained Sonic Pi render pipeline.
1. Starts systemd service
2. Waits for boot
3. Sends a trigger note (creates SuperCollider PipeWire ports)
4. Links SuperCollider -> sonic_pi_render sink
5. Records from sonic_pi_render sink (by node name, not default)
6. Sends showcase code + keep-alive for ~95 seconds
7. Stops recording, reports stats
"""
import socket, struct, time, subprocess, signal, os, re, sys

def osc_msg(path, args=[]):
    nul = chr(0).encode()
    msg = path.encode() + nul
    while len(msg) % 4: msg += nul
    types = ","
    for a in args:
        if isinstance(a, str): types += "s"
        elif isinstance(a, int): types += "i"
    msg += types.encode() + nul
    while len(msg) % 4: msg += nul
    for a in args:
        if isinstance(a, str):
            s = a.encode() + nul
            while len(s) % 4: s += nul
            msg += s
        elif isinstance(a, int): msg += struct.pack(">i", a)
    return msg

def get_spider_info():
    """Extract spider port + token from /proc/cmdline"""
    pids = subprocess.check_output(["pgrep", "-f", "spider-server.rb"]).decode().strip().split("\n")
    for pid in pids:
        try:
            cmdline = open(f"/proc/{pid}/cmdline", "rb").read().decode().split("\0")
            # Find -u, next arg is spider port (first in the port list)
            if "-u" in cmdline:
                idx = cmdline.index("-u")
                spider_port = int(cmdline[idx + 1])
                token = int(cmdline[-2])  # last numeric arg before empty
                return spider_port, token
        except:
            continue
    return None, None

def get_daemon_port():
    """Get daemon port from journal"""
    journal = subprocess.check_output(["journalctl", "--user", "-u", "sonic-pi", "--no-pager", "-n", "5"]).decode()
    # Port line: 8 numbers separated by spaces
    for line in journal.split("\n"):
        m = re.search(r'(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(-?\d+)', line)
        if m:
            return int(m.group(1))
    return None

def wait_for_sc_ports(timeout=30):
    """Wait for SuperCollider PipeWire ports to appear"""
    for _ in range(timeout):
        result = subprocess.run(["pw-link", "-o"], capture_output=True, text=True)
        if "SuperCollider:out_1" in result.stdout:
            return True
        time.sleep(1)
    return False

# ===== MAIN =====

# Step 1: Start service
print("Starting Sonic Pi service...")
subprocess.run(["systemctl", "--user", "start", "sonic-pi"])
time.sleep(12)

# Step 2: Get ports
spider_port, token = get_spider_info()
daemon_port = get_daemon_port()
print(f"Spider: {spider_port}, Daemon: {daemon_port}, Token: {token}")

if not spider_port or not daemon_port:
    print("ERROR: Could not get ports")
    sys.exit(1)

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind(("127.0.0.1", 0))

# Send initial keep-alive
sock.sendto(osc_msg("/daemon/keep-alive", [token]), ("127.0.0.1", daemon_port))

# Step 3: Send trigger note to create SuperCollider PipeWire ports
print("Sending trigger note...")
sock.sendto(osc_msg("/run-code", [token, "play 72, release: 0.05, amp: 0.05\n"]), ("127.0.0.1", spider_port))
time.sleep(3)

# Step 4: Wait for SC ports and link
if wait_for_sc_ports():
    print("SuperCollider ports found, linking...")
    subprocess.run(["pw-link", "SuperCollider:out_1", "sonic_pi_render:playback_FL"], capture_output=True)
    subprocess.run(["pw-link", "SuperCollider:out_2", "sonic_pi_render:playback_FR"], capture_output=True)
else:
    print("WARNING: SuperCollider ports not found, trying link anyway...")

# Step 5: Find the sonic_pi_render node ID for targeted recording
wp_status = subprocess.check_output(["wpctl", "status"], text=True)
# Parse node ID from the output - look for sonic_pi_render
node_id = None
for line in wp_status.split("\n"):
    if "sonic_pi_render" in line.lower() or "Sonic_Pi_Render" in line:
        m = re.match(r'\s*(\d+)\.', line)
        if m:
            node_id = m.group(1)
            break
print(f"sonic_pi_render node ID: {node_id}")

# Step 6: Start recording with explicit target
output_file = "/tmp/wraith_showcase_v2.wav"
if node_id:
    # pw-record with --target to explicitly capture from the sonic_pi_render sink
    rec = subprocess.Popen(["pw-record", "--target", node_id, output_file])
else:
    print("ERROR: Could not find sonic_pi_render node")
    sys.exit(1)

time.sleep(1)

# Step 7: Send the showcase code
with open("/tmp/wraith_showcase.rb") as f:
    code = f.read()
sock.sendto(osc_msg("/run-code", [token, code]), ("127.0.0.1", spider_port))
print(f"Sent showcase ({len(code)} bytes)")

# Step 8: Keep alive for 95 seconds
for i in range(48):
    sock.sendto(osc_msg("/daemon/keep-alive", [token]), ("127.0.0.1", daemon_port))
    time.sleep(2)

# Step 9: Stop
sock.sendto(osc_msg("/stop-all-jobs", [token]), ("127.0.0.1", spider_port))
time.sleep(2)
rec.send_signal(signal.SIGINT)
rec.wait()
sock.close()

# Step 10: Report stats
stat = subprocess.run(["sox", output_file, "-n", "stat"], capture_output=True, text=True)
print("=== STATS ===")
for line in stat.stderr.split("\n"):
    if any(k in line for k in ["Length", "Maximum amplitude", "RMS"]):
        print(line)
print(f"Output: {output_file}")
print("Pipeline complete")