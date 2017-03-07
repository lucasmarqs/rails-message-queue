Rails.application.configure do
  conn = Bunny.new host: 'mqp'
  conn.start

  ch  = conn.create_channel
  x = ch.topic("blogui", :auto_delete => true)

  ch.queue('', exclusive: true).bind(x, routing_key: 'post.create').subscribe do |delivery_info, metadata, payload|
    PostExchange.new(payload).run
  end
end
