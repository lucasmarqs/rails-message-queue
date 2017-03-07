class PostExchange
  attr_reader :text

  def initialize(text)
    @text = text
  end

  def run
    Post.create(text: text)
  end
end
