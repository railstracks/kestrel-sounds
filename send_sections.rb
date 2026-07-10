#!/usr/bin/env ruby
# send_sections.rb — Send Sonic Pi code sections via OSC
# Usage: ruby send_sections.rb <port> <token> <code_file>

require 'socket'

module OSC
  module Encoder
    def self.pad32(s); s + ("\x00" * ((4 - s.length % 4) % 4)); end
    def self.encode_message(path, *args)
      types = args.map { |a| case a; when String then 's'; when Integer then 'i'; when Float then 'f'; else 's'; end }.join
      msg = pad32(path + "\x00"); msg += pad32("," + types + "\x00")
      args.each { |a| case a; when String then msg += pad32(a + "\x00"); when Integer then msg += [a].pack('N'); when Float then msg += [a].pack('g'); end }
      msg
    end
  end
end

port = ARGV[0].to_i
token_raw = ARGV[1].to_i
token = token_raw < 0 ? token_raw + 2**32 : token_raw
code_file = ARGV[2]

puts "Port: #{port}, Token: #{token}"

full_code = File.read(code_file, encoding: 'UTF-8')
raw_parts = full_code.split(/^# ===+/m).reject { |s| s.strip.empty? }
stripped = raw_parts.map { |s| s.gsub(/^\s*#.*$/, '').gsub(/\s+#.*$/, '').strip }
header = stripped[0]
body_sections = stripped[1..-1].reject { |s| s.empty? }

puts "Header: #{header.length} bytes, #{body_sections.length} sections"
body_sections.each_with_index { |s, i| puts "  Section #{i+1}: #{s.length} bytes" }

sock = UDPSocket.new
sock.connect('127.0.0.1', port)

# Send header (replace newlines with semicolons for OSC compatibility)
header_osc = header.gsub("\n", "; ")
sock.send(OSC::Encoder.encode_message('/run-code', token, header_osc), 0)
puts "Sent header"
sleep 5

# Check spider is alive
puts "Spider still alive check..."
begin
  # Try sending a trivial code to test
  sock.send(OSC::Encoder.encode_message('/run-code', token, " "), 0)
  puts "Spider alive after header"
rescue => e
  puts "Spider dead after header: #{e.message}"
  exit 1
end
sleep 2

# Send each body section
section_waits = [65, 50, 35, 50, 30]

body_sections.each_with_index do |sec, i|
  sec_osc = sec.gsub("\n", "; ")
  puts "Sending section #{i+1} (#{sec_osc.length} bytes)..."
  begin
    sock.send(OSC::Encoder.encode_message('/run-code', token, sec_osc), 0)
    wait = section_waits[i] || 40
    puts "  Sent, waiting #{wait}s"
    sleep wait
  rescue => e
    puts "  ERROR: #{e.message}"
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
puts "All done"