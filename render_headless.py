#!/usr/bin/env python3
"""
Sonic Pi Headless Render Pipeline — WORKING VERSION
Validated 2026-07-05 with wraith_render.flac

Usage:
  python3 render_headless.py <output.wav> <piece.rb> [duration_seconds]

Requirements:
  - Sonic Pi 4.6 daemon.rb path below
  - parecord (NOT pw-record — pw-record ignores --target)
  - pw-link, pactl, sox
  - Custom synthdefs in ~/.local/share/SuperCollider/synthdefs/
  - Code must use individual play() calls, NOT arrays/chords (headless limitation)

See RENDER_PIPELINE.md for full documentation.
"""
import socket, struct, time, subprocess, re, os, threading, signal, sys

def osc(path, args=[]):
    """Build OSC 1.0 message. Supports str, int, float args."""
    nul = chr(0).encode()
    msg = path.encode() + nul
    while len(msg) % 4: msg += nul
    t = ","
    for a in args:
        if isinstance(a, str): t += "s"
        elif isinstance(a, int): t += "i"
        elif isinstance(a, float): t += "f"
    msg += t.encode() + nul
    while len(msg) % 4: msg += nul
    for a in args:
        if isinstance(a, str):
            s = a.encode() + nul
            while len(s) % 4: s += nul
            msg += s
        elif isinstance(a, int): msg += struct.pack(">i", a)
        elif isinstance(a, float): msg += struct.pack(">f", a)
    return msg

# Config
DAEMON_RB = "/home/melvin/Development/sonic-pi/app/server/ruby/bin/daemon.rb"
SINK_NAME = "kc_test"
OUTFILE = sys.argv[1] if len(sys.argv) > 1 else "/tmp/sc_render.wav"
RBFILE = sys.argv[2] if len(sys.argv) > 2 else "/tmp/wraith_headless.rb"
DURATION = int(sys.argv[3]) if len(sys.argv) > 3 else 100

# 1. Cleanup
for p in ["beam.smp", "spider-server", "scsynth", "daemon.rb"]:
    subprocess.run(["pkill", "-9", "-f", p], capture_output=True)
time.sleep(2)
print("Cleaned up old processes", flush=True)

# 2. Start daemon
env = os.environ.copy()
env["QT_QPA_PLATFORM"] = "offscreen"
daemon = subprocess.Popen(
    ["/usr/bin/ruby", DAEMON_RB],
    env=env, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL
)
port_line = daemon.stdout.readline().decode().strip()
nums = re.findall(r"-?\d+", port_line)
if len(nums) < 8:
    print(f"ERROR: bad port line: {port_line}")
    sys.exit(1)
dport, sport, token = int(nums[0]), int(nums[2]), int(nums[7])
print(f"daemon={dport} spider={sport} token=***", flush=True)

# 3. Keep-alive thread (daemon dies after ~3s without it)
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind(("127.0.0.1", 0))
stop_ev = threading.Event()
def keep_alive():
    while not stop_ev.is_set():
        try:
            sock.sendto(osc("/daemon/keep-alive", [token]), ("127.0.0.1", dport))
        except:
            break
        stop_ev.wait(1.5)
threading.Thread(target=keep_alive, daemon=True).start()
print("Keep-alive thread started", flush=True)
time.sleep(5)

# 4. Create null sink
subprocess.run(["pactl", "unload-module", "module-null-sink"], capture_output=True)
time.sleep(1)
subprocess.run(["pactl", "load-module", "module-null-sink", f"sink_name={SINK_NAME}"],
               capture_output=True)
print(f"Null sink '{SINK_NAME}' created", flush=True)

# 5. Trigger note to create SuperCollider PipeWire ports
sock.sendto(osc("/run-code", [token, "play 60, release: 0.05, amp: 0.1\n"]),
            ("127.0.0.1", sport))
time.sleep(3)

# 6. Link SC to null sink
for attempt in range(10):
    links = subprocess.check_output(["pw-link", "-l"], text=True)
    if "SuperCollider:out_1" in links:
        subprocess.run(["pw-link", "SuperCollider:out_1", f"{SINK_NAME}:playback_FL"],
                       capture_output=True)
        subprocess.run(["pw-link", "SuperCollider:out_2", f"{SINK_NAME}:playback_FR"],
                       capture_output=True)
        print(f"SC linked to {SINK_NAME}", flush=True)
        break
    time.sleep(1)
else:
    print("WARNING: SC ports not found, continuing anyway", flush=True)

# 7. Start parecord (NOT pw-record!)
rec = subprocess.Popen(
    ["parecord", f"--device={SINK_NAME}.monitor", "--file=wav", OUTFILE],
    stderr=subprocess.PIPE, stdout=subprocess.PIPE
)
print(f"parecord PID={rec.pid}", flush=True)
time.sleep(1)

# 8. Verify parecord is on the null sink (not webcam mic)
links = subprocess.check_output(["pw-link", "-l"], text=True)
if "webcam" in links and "parecord" in links:
    print("WARNING: parecord appears connected to WEBCAM MIC!", flush=True)
elif f"{SINK_NAME}:monitor" in links and "parecord" in links:
    print(f"Verified: parecord → {SINK_NAME}.monitor", flush=True)

# 9. Send the piece
with open(RBFILE) as f:
    code = f.read()
sock.sendto(osc("/run-code", [token, code]), ("127.0.0.1", sport))
print(f"Piece sent ({len(code)} bytes)", flush=True)

# 10. Wait for duration
for i in range(DURATION):
    time.sleep(1)
    if i > 0 and i % 10 == 0:
        print(f"  {i}s...", flush=True)

# 11. Stop
sock.sendto(osc("/stop-all-jobs", [token]), ("127.0.0.1", sport))
time.sleep(2)
rec.send_signal(signal.SIGINT)
rec.wait(timeout=5)
print("Recording stopped", flush=True)

stop_ev.set()
sock.close()
daemon.terminate()

# 12. Fix WAV header (parecord doesn't update data size on exit)
fsize = os.path.getsize(OUTFILE)
with open(OUTFILE, 'r+b') as f:
    f.seek(12)
    while True:
        cid = f.read(4)
        if len(cid) < 4: break
        csize = struct.unpack('<I', f.read(4))[0]
        if cid == b'data':
            actual = fsize - f.tell()
            f.seek(f.tell() - 4)
            f.write(struct.pack('<I', actual))
            f.seek(4)
            f.write(struct.pack('<I', fsize - 8))
            break
        f.seek(csize, 1)

# 13. Report stats
st = subprocess.run(["sox", OUTFILE, "-n", "stat"], capture_output=True, text=True)
print("\n=== AUDIO STATS ===", flush=True)
for s in st.stderr.split("\n"):
    if any(k in s for k in ["Length", "Maximum amplitude", "RMS"]):
        print(f"  {s.strip()}", flush=True)

# Sanity check
for s in st.stderr.split("\n"):
    if "Maximum amplitude" in s:
        val = float(s.split(":")[1].strip())
        if val < 0.01:
            print("WARNING: Near-zero amplitude. Likely silence. Check code for chords/arrays.", flush=True)
        elif val < 0.1:
            print("WARNING: Low amplitude. May be microphone noise, not synth.", flush=True)
        else:
            print("Amplitude looks good — likely real synth audio.", flush=True)