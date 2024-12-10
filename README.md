# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...

- config.force_ssl = false # TODO: should be in true

## COMMANDS

- bundle exec wheneverize
- whenever --update-crontab
- crontab -l
- RAILS_ENV=production rails db:create db:migrate
- RAILS_ENV=production rails assets:precompile

## KARAFKA

- bundle add karafka --version ">= 2.4.0"
- bundle exec karafka install
- karafka g consumer SimpleConsumer
- bundle exec karafka server

## TAPIOCA

- bundle exec tapioca init
- bin/tapioca dsl

## VALIDATE SORBET TYPES

- srb tc
