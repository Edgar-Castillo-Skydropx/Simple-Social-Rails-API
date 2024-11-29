#!/bin/bash
set -e

# Create empty crontab file.
crontab -l | { cat; echo ""; } | crontab -

# Update crontab file using whenever command.
bundle exec whenever --set 'environment=production' --update-crontab

echo "Executing migrations and tasks relations with the database..."
bundle exec rake db:create db:migrate

exec "$@"
