class MessagePublisher
  def self.call(payload, topic)
    puts "PUBLISHING EVENT...."
    Karafka.producer.produce_sync(topic: topic, payload: payload.to_json)
  end
end
