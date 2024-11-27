namespace :jobs do
  desc "Update task date from Posts"
  task update_task: :environment do
    UpdateTaskDateJob.perform_now
  end
end
