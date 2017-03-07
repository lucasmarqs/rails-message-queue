require "bunny"

if ARGV.empty?
  abort "Usage: #{$0} [post text]'"
end

conn = Bunny.new host: 'mqp'
conn.start

ch  = conn.create_channel
x = ch.topic("blogui", :auto_delete => true)

ARGV.each do |text|
  x.publish(text, routing_key: 'post.create')
  puts "[x] Sent post.create:#{text}"
end

ch.close
conn.close
