#!/bin/bash
set -e

echo "Executing migrations and tasks relations with the database..."
bundle exec rake db:create db:migrate

exec "$@"
