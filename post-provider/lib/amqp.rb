class Amqp
  attr_reader :conn

  def initialize(**params)
    @conn = Bunny.new **params
    @conn.start
  end
end
