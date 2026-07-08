#!/usr/bin/env ruby
# section_render.rb — Render a Sonic Pi file section by section
# Each section is sent separately, with a pause to let notes decay
# Usage: ruby section_render.rb <code_file> <output_wav> <total_duration>

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

port_file = '/tmp/sonic_pi_ports.txt'
cfg = {}
File.readlines(port_file).each { |l| k,v = l.strip.split('=',2); cfg[k] = v if k }
SPIDER_PORT = (cfg['SPIDER_PORT']||4557).to_i
TOKEN = (cfg['TOKEN']||0).to_i
SINK = cfg['SINK_NAME'] || 'sonic_pi_render'

code_file = ARGV[0]; output_wav = ARGV[1] || '/tmp/render.wav'; total_dur = (ARGV[2]||30).to_i

# Read the full code
full_code = File.read(code_file)

# Split into sections at the section markers
sections = full_code.split(/^# ===+/m).reject { |s| s.strip.empty? }

# Re-add the header (first chunk is the header + setup)
header = sections[0]
body_sections = sections[1..-1]

puts "Rendering #{File.basename(code_file)} (#{total_dur}s) -> #{output_wav}"
puts "Sections: #{body_sections.length}"

# Start recording
rec_pid = spawn("parec", "--device=#{SINK}.monitor", "--file-format=wav", output_wav)
sleep 1

sock = UDPSocket.new; sock.connect('127.0.0.1', SPIDER_PORT)

# Send header (BPM, external synths setup)
sock.send(OSC::Encoder.encode_message('/run-code', TOKEN, header.gsub(/^\s*#.*/, '').gsub(/\s+#.*$/, '')), 0)
sleep 2

# Send each body section separately with a stop between them
body_sections.each_with_index do |sec, i|
  # Send stop before each section (except handle it carefully)
  # Just send the section code — notes will naturally decay with short releases
  code = sec.gsub(/^\s*#.*/, '').gsub(/\s+#.*$/, '')
  sock.send(OSC::Encoder.encode_message('/run-code', TOKEN, code), 0)
  puts "Sent section #{i+1}/#{body_sections.length}"
  sleep 30 # Wait for section to play out
end

sleep 5
sock.send(OSC::Encoder.encode_message('/stop-all-jobs', TOKEN, 0), 0)
sleep 2
Process.kill('INT', rec_pid); Process.wait(rec_pid); sock.close

size = File.size(output_wav); puts "Done: #{'%.1f' % (size/1048576.0)} MB"