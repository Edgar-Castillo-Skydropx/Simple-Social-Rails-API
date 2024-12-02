class UpdateTaskDateJob < ApplicationJob
  queue_as :default

  def perform(date)
    puts "EXECUTING UPDATE_TASK CRON_JOB..."
    Post.update_all(task_date: date)
  end
end
