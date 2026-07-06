# Headless Render Pipeline — Tested Method

**Last validated:** 2026-07-05 (wraith_render.flac confirmed by ear)

## Overview

Render Sonic Pi music headlessly on Melvin's workstation (melvin-E33011). The daemon runs without a GUI, outputs to a PipeWire null sink, and `parecord` captures the monitor output.

## Two Critical Gotchas

### 1. `pw-record` ALWAYS records from the microphone

`pw-record --target <anything>` silently ignores the target and records from the default source (webcam mic). This was the cause of **every** "ambient microphone input" result across multiple sessions. Numeric IDs, node names, PULSE_SOURCE env var — none of it works.

**Fix:** Use `parecord --device=<sink_name>.monitor` instead. Parecord correctly connects to the specified monitor source.

### 2. Headless spider server cannot play arrays with custom synthdefs

`play chord(:e3, :minor)`, `play [:e3, :g3, :b3]`, `play (scale :e3, :minor_pentatonic)` — all produce **silence** when used with custom synthdefs (like `:kestrel_wraith`). No error is logged. Built-in synths (prophet, etc.) may work with arrays, but custom synthdefs do not.

**Fix:** Expand all chords and arrays into individual `play` calls:
```ruby
# BAD — silence
play chord(:e3, :minor7), release: 4, amp: 0.2

# GOOD — works
play :e3, release: 4, amp: 0.2
play :g3, release: 4, amp: 0.2
play :b3, release: 4, amp: 0.2
play :d4, release: 4, amp: 0.2
```

## Prerequisites

- Sonic Pi 4.6 built from source at `/home/melvin/Development/sonic-pi/`
- Custom synthdefs in `~/.local/share/SuperCollider/synthdefs/`
- `parecord` (pulseaudio-utils), `pw-link` (pipewire-tools), `sox`
- `use_external_synths true` required in Sonic Pi code for custom synthdefs

## Step-by-Step Pipeline

### 1. Start daemon.rb (systemd service)

```ini
# ~/.config/systemd/user/sonic-pi.service
[Unit]
Description=Sonic Pi 4.6 Headless
After=pipewire.service

[Service]
Type=simple
Environment=QT_QPA_PLATFORM=offscreen
ExecStart=/usr/bin/ruby /home/melvin/Development/sonic-pi/app/server/ruby/bin/daemon.rb
Restart=no
```

```bash
systemctl --user start sonic-pi
# Wait ~8 seconds for boot
```

The daemon prints a port line to journalctl:
```
PORT1 PORT2 PORT3 PORT4 PORT5 PORT6 PORT7 TOKEN
```
- PORT1 (index 0) = daemon port (keep-alive target)
- PORT3 (index 2) = spider port (run-code target)
- PORT4 (index 3) = scsynth port

### 2. Send keep-alive every 1.5 seconds

The daemon self-terminates if it doesn't receive `/daemon/keep-alive` OSC messages with the correct token within ~3 seconds. A background thread must send these continuously.

```python
sock.sendto(osc("/daemon/keep-alive", [token]), ("127.0.0.1", daemon_port))
```

**Warning:** The token can be negative (e.g., `-2069780301`). Parse it as a signed integer.

### 3. Create null sink and link SuperCollider

```bash
# Create a fresh null sink (remove old one first)
pactl unload-module module-null-sink 2>/dev/null
pactl load-module module-null-sink sink_name=kc_test

# Send a trigger note to create SC PipeWire ports
# (via OSC /run-code to spider port)
# Then link:
pw-link "SuperCollider:out_1" "kc_test:playback_FL"
pw-link "SuperCollider:out_2" "kc_test:playback_FR"
```

**Note:** SuperCollider also auto-links to HDMI (`alsa_output.pci-0000_01_00.1.hdmi-stereo`). The additional link to `kc_test` runs in parallel. You don't need to disconnect HDMI.

### 4. Record with parecord

```bash
parecord --device=kc_test.monitor --file=wav /tmp/output.wav
```

**NOT** `pw-record`. Parecord is the only tool that respects the device target.

### 5. Send code and wait

```python
sock.sendto(osc("/run-code", [token, ruby_code]), ("127.0.0.1", spider_port))
```

Keep sending keep-alive for the duration of the piece. Node exec calls timeout at ~30s, so for pieces longer than ~25s, send keep-alive in batches across multiple exec calls, or run the entire pipeline as a single Python script with `nohup`.

### 6. Convert and transfer

```bash
sox /tmp/output.wav /tmp/output.flac gain -n -3  # normalize to -3dB
# Transfer via midas-srv relay:
# ssh claw@steadyfort.com "scp -P 2246 melvin@localhost:/tmp/file.flac /tmp/file.flac"
# scp claw@steadyfort.com:/tmp/file.flac /tmp/file.flac
```

## Verification Method

To verify a capture is real synth audio (not microphone noise):

1. **Silence test:** Record 3 seconds with no note playing. Must show `Maximum amplitude: 0.000000`. Any non-zero value = microphone bleed.
2. **Amplitude check:** Real synth notes produce max amplitude 0.3–0.9. Webcam mic noise typically peaks around 0.1–0.2 with RMS > 0.01 even during "silence".
3. **Link verification:** Check `pw-link -l` during recording. `parecord:input_FL ← kc_test:monitor_FL` = correct. `pw-record:input_MONO ← alsa_input...webcam` = wrong.

## Code Constraints for Headless Rendering

When writing Sonic Pi code for headless rendering:

1. **No arrays/chords in `play`** — expand to individual notes
2. **`use_external_synths true`** required for custom synthdefs
3. **`use_bpm` works fine**
4. **`in_thread` works fine**
5. **Multi-line params with trailing commas work fine**
6. **Single notes with custom params work fine**

## Scripts

- `render_pipeline.py` — legacy (broken, uses pw-record)
- `/tmp/quick_render.py` — working render script (deployed July 5)
- `/tmp/final_render.py` — working render with verbose link logging

## OSC Helper

All scripts use the same `osc()` function to build OSC 1.0 messages:
```python
def osc(path, args=[]):
    # Standard OSC address + type tag + args encoding
    # Supports: strings (s), ints (i), floats (f)
```
