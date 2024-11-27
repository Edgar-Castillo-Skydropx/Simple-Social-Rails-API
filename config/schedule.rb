# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

set :output, "log/cron.log" # Opcional, para registrar errores y salidas
set :environment, "development"
set :bundle_command, "bundle exec"

env :PATH, ENV["PATH"] # Asegúrate de tener acceso a binarios como bundle

every 1.minutes do
  runner "puts 'Hello World'"
  # rake "jobs:update_task"
end
# Learn more: http://github.com/javan/whenever
