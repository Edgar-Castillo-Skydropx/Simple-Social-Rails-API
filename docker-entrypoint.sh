#!/bin/bash
set -e

echo "Ejecutando migraciones y tareas relacionadas con la base de datos..."
bundle exec rake db:create db:migrate

exec "$@"
