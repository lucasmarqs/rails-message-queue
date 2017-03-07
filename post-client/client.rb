require "bunny"
require "json"

if ARGV.empty?
  abort "Usage: #{$0} [post text]'"
end

conn = Bunny.new host: 'mqp'
conn.start

ch  = conn.create_channel
x = ch.topic("blogui", auto_delete: true)

ch.queue('', exclusive: true).bind(x, routing_key: 'post.create.response').subscribe do |delivery_info, metadata, payload|
  puts "[x] Post created: #{JSON.parse(payload)}"
end

ARGV.each do |text|
  x.publish(text, routing_key: 'post.create')
  puts "[x] Sent post.create:#{text}"
end

begin
rescue Interrupt => _
  conn.close
end while (true)

ch.close
conn.close
