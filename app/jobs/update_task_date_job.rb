class UpdateTaskDateJob < ApplicationJob
  queue_as :default

  def perform
    puts "EXECUTING UPDATE_TASK CRON_JOB..."
    Post.update_all(task_date: Time.now.strftime("%d/%m/%Y %H:%M"))
  end
end
