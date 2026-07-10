#!/usr/bin/env ruby
# render_24.rb — Render Study 24 via OSC + pw-record
# Usage: ruby render_24.rb <code_file> <output_wav>

require 'socket'

module OSC
  module Encoder
    def self.pad32(s); s + ("\x00" * ((4 - s.length % 4) % 4)); end
    def self.encode_message(path, *args)
      types = args.map { |a| case a; when String then 's'; when Integer then 'i'; when Float then 'f'; else 's'; end }.join
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

code_file = ARGV[0] || '24_memory.rb'
output_wav = ARGV[1] || '/tmp/24_memory.wav'

# Read port info from daemon log
# Format: daemon_pid gui_listen gui_send scsynth_send scsynth_recv osc_cues tau tau_phx token
port_line = File.readlines('/tmp/sp24.log').find { |l| l.strip.match?(/^\-?\d/) }
parts = port_line.strip.split
spider_port = parts[2].to_i
# Token might be negative — pack as signed int32
token_raw = parts[7].to_i
token = token_raw < 0 ? token_raw + 2**32 : token_raw
puts "Spider port: #{spider_port}, Token: #{token} (raw: #{token_raw})"

# Read the full code with comments (for section splitting)
full_code = File.read(code_file, encoding: 'UTF-8')

# Split at section markers (lines starting with # ===)
raw_parts = full_code.split(/^# ===+/m).reject { |s| s.strip.empty? }

# Strip comments from each part
stripped = raw_parts.map { |s| s.gsub(/^\s*#.*$/, '').gsub(/\s+#.*$/, '').strip }

# First part is the header
header = stripped[0]
body_sections = stripped[1..-1].reject { |s| s.empty? }

puts "Header: #{header.length} bytes"
puts "Body sections: #{body_sections.length}"
body_sections.each_with_index { |s, i| puts "  Section #{i+1}: #{s.length} bytes" }

# Start pw-record
rec_pid = spawn("pw-record", "--target", "SuperCollider", "--rate", "48000", "--channels", "2", "--format", "f32", output_wav)
sleep 2
puts "Recording started (pid #{rec_pid})"

sock = UDPSocket.new
sock.connect('127.0.0.1', spider_port)

# Send test note to verify connection
test_code = "play :E3, release: 0.5, amp: 0.2"
sock.send(OSC::Encoder.encode_message('/run-code', token, test_code), 0)
puts "Sent test note"
sleep 3

# Check if spider is still alive
begin
  sock.send(OSC::Encoder.encode_message('/run-code', token, header), 0)
  puts "Sent header"
rescue => e
  puts "ERROR sending header: #{e.message}"
  Process.kill('INT', rec_pid)
  Process.wait(rec_pid)
  exit 1
end
sleep 3

# Section wait times
section_waits = [65, 50, 35, 50, 30]

body_sections.each_with_index do |sec, i|
  begin
    sock.send(OSC::Encoder.encode_message('/run-code', token, sec), 0)
    wait = section_waits[i] || 40
    puts "Sent section #{i+1}/#{body_sections.length} (#{sec.length} bytes, waiting #{wait}s)"
    sleep wait
  rescue => e
    puts "ERROR on section #{i+1}: #{e.message}"
    break
  end
end

sleep 5
begin
  sock.send(OSC::Encoder.encode_message('/stop-all-jobs', token), 0)
  puts "Sent stop"
rescue => e
  puts "ERROR sending stop: #{e.message}"
end
sleep 2
sock.close

Process.kill('INT', rec_pid)
Process.wait(rec_pid)
puts "Recording stopped"

if File.exist?(output_wav)
  size = File.size(output_wav)
  puts "Done: #{'%.1f' % (size / 1048576.0)} MB -> #{output_wav}"
else
  puts "ERROR: output file not created"
end