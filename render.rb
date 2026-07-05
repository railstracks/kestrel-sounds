#!/usr/bin/env ruby
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

code_file = ARGV[0]; output_wav = ARGV[1] || '/tmp/render.wav'; duration = (ARGV[2]||30).to_i
code = File.read(code_file).gsub(/^\s*#.*/, '').gsub(/\s+#.*$/, '')

puts "Rendering #{File.basename(code_file)} (#{duration}s) -> #{output_wav}"
rec_pid = spawn("parec", "--device=#{SINK}.monitor", "--file-format=wav", output_wav)
sleep 1

sock = UDPSocket.new; sock.connect('127.0.0.1', SPIDER_PORT)
sock.send(OSC::Encoder.encode_message('/run-code', TOKEN, code), 0)
puts "Code sent to port #{SPIDER_PORT} (token #{TOKEN})"

sleep duration
sock.send(OSC::Encoder.encode_message('/stop-all-jobs', TOKEN), 0)
sleep 2
Process.kill('INT', rec_pid); Process.wait(rec_pid); sock.close

size = File.size(output_wav); puts "Done: #{'%.1f' % (size/1048576.0)} MB"
