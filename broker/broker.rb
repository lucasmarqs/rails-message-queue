require "bunny"

conn = Bunny.new host: 'mqp'
conn.start

ch  = conn.create_channel
x = ch.topic("blogui", :auto_delete => true)

puts " [*] Waiting for logs. To exit press CTRL+C"

begin
  ch.queue('', exclusive: true).bind(x, routing_key: 'post.create').subscribe do |delivery_info, metadata, payload|
      puts " [x] #{delivery_info.routing_key}:#{payload}"
  end
rescue Interrupt => _
  puts "Closing connections..."

  ch.close
  conn.close
end

