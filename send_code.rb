#!/usr/bin/env ruby
# send_code.rb — Send Sonic Pi code via OSC to the headless server
# Usage: ruby send_code.rb <code_file> [stop]

require 'socket'

module OSC
  module Encoder
    def self.encode_string(s)
      s + "\x00" + ("\x00" * ((4 - (s.length + 1) % 4) % 4))
    end

    def self.encode_int32(i)
      [i].pack('N')
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

      msg = encode_string(path)
      # Remove the padding from path and append type string
      msg = path + "\x00"
      msg += "\x00" * ((4 - msg.length % 4) % 4) if msg.length % 4 != 0
      
      # Append type tag string with leading comma
      type_str = "," + types + "\x00"
      type_str += "\x00" * ((4 - type_str.length % 4) % 4) if type_str.length % 4 != 0
      msg += type_str

      args.each { |a|
        case a
        when String
          s = a + "\x00"
          s += "\x00" * ((4 - s.length % 4) % 4) if s.length % 4 != 0
          msg += s
        when Integer
          msg += [a].pack('N')
        when Float
          msg += [a].pack('g')
        end
      }

      msg
    end
  end
end

command = ARGV[0] || 'run'
sock = UDPSocket.new
sock.connect('127.0.0.1', 4557)

case command
when 'run'
  code = File.read(ARGV[1])
  # Strip comments to avoid Unicode/OSC decoder bug
  code = code.gsub(/^\s*#.*/, '').gsub(/\s+#.*$/, '')
  msg = OSC::Encoder.encode_message('/run-code', 0, code)
  sock.send(msg, 0)
  puts "Sent /run-code (#{code.length} bytes)"
when 'stop'
  msg = OSC::Encoder.encode_message('/stop-all-jobs', 0)
  sock.send(msg, 0)
  puts "Sent /stop-all-jobs"
when 'record-start'
  # /recording-start with path
  path = ARGV[1]
  msg = OSC::Encoder.encode_message('/recording-start', 0, path)
  sock.send(msg, 0)
  puts "Sent /recording-start -> #{path}"
when 'record-stop'
  msg = OSC::Encoder.encode_message('/recording-stop', 0)
  sock.send(msg, 0)
  puts "Sent /recording-stop"
when 'test'
  # Simple test: play a note
  code = "use_synth :prophet; play :E3, release: 2, cutoff: 80, amp: 0.3"
  msg = OSC::Encoder.encode_message('/run-code', 0, code)
  sock.send(msg, 0)
  puts "Sent test note"
end

sock.close