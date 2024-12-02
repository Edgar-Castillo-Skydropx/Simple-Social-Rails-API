# frozen_string_literal: true

class UpdateTaskConsumer < ApplicationConsumer
  def consume
    puts "###### Listening Update Task Domain Event... ######"
    messages.each { |message| UpdateTaskDateJob.perform_now(message.payload["date"]) }
  end

  # Run anything upon partition being revoked
  # def revoked
  # end

  # Define here any teardown things you want when Karafka server stops
  # def shutdown
  # end
end
