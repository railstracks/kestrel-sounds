#!/usr/bin/env ruby
# render.rb — Render Sonic Pi code to WAV via headless server
# Usage: ruby render.rb <code_file> <output_wav> <duration_seconds>
#
# Prerequisites:
#   - Sonic Pi server running headless on port 4557
#   - PulseAudio null sink 'sonic_pi_render' created
#   - SuperCollider output routed to the null sink
#
# The script:
#   1. Starts recording from the null sink monitor via parec
#   2. Sends the Sonic Pi code via OSC to the server
#   3. Waits for the specified duration
#   4. Stops playback and recording
#   5. Reports the output file size

require 'socket'

module OSC
  module Encoder
    def self.pad32(s)
      s + ("\x00" * ((4 - s.length % 4) % 4))
    end

    def self.encode_message(path, *args)
      types = args.map { |a|
        case a
        when String then 's'
        when Integer then 'i'
        when Float then 'f'
        else 's'
        end
      }.join

      msg = pad32(path + "\x00")
      msg += pad32("," + types + "\x00")
      args.each { |a|
        case a
        when String then msg += pad32(a + "\x00")
        when Integer then msg += [a].pack('N')
        when Float then msg += [a].pack('g')
        end
      }
      msg
    end
  end
end

class SonicPiClient
  def initialize(host = '127.0.0.1', port = 4557)
    @sock = UDPSocket.new
    @sock.connect(host, port)
  end

  def run_code(code)
    msg = OSC::Encoder.encode_message('/run-code', 0, code)
    @sock.send(msg, 0)
  end

  def stop_all
    msg = OSC::Encoder.encode_message('/stop-all-jobs', 0)
    @sock.send(msg, 0)
  end

  def close
    @sock.close
  end
end

# --- Main ---

code_file = ARGV[0]
output_wav = ARGV[1] || '/tmp/sonic-pi-output.wav'
duration = (ARGV[2] || 30).to_i

unless code_file && File.exist?(code_file)
  STDERR.puts "Usage: ruby render.rb <code_file> <output_wav> <duration_seconds>"
  exit 1
end

raw_code = File.read(code_file)
# Strip comments to avoid Unicode/OSC decoder bug (em dashes, arrows, etc. break oscdecode.rb)
code = raw_code.gsub(/^\s*#.*/, '').gsub(/\s+#.*$/, '')
puts "Render: #{File.basename(code_file)}"
puts "  Output: #{output_wav}"
puts "  Duration: #{duration}s"

# Start recording
rec_pid = spawn("parec", "--device=sonic_pi_render.monitor", "--file-format=wav", output_wav)
puts "  Recording PID: #{rec_pid}"
sleep 1

# Send code
client = SonicPiClient.new
client.run_code(code)
puts "  Code sent (#{code.length} bytes)"

# Wait
sleep duration

# Stop playback
client.stop_all
puts "  Stopping playback..."
sleep 2

# Stop recording
Process.kill('INT', rec_pid)
Process.wait(rec_pid)
client.close

# Report
if File.exist?(output_wav)
  size = File.size(output_wav)
  mb = size / 1024.0 / 1024.0
  puts "  Done: #{output_wav} (#{'%.1f' % mb} MB)"
else
  puts "  ERROR: Output file not created!"
  exit 1
end