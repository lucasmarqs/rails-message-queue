class PostExchange
  attr_reader :post

  def initialize(text, exchange:)
    @post = Post.new(text: text)
    @exchange = exchange
  end

  def run
    if post.save
      @exchange.publish(post.to_json, routing_key: 'post.create.response')
    end
  end
end
