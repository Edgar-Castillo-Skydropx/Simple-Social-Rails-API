# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.2.2

FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips postgresql-client cron && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Final stage for app image
FROM base

# Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Crear grupo y usuario rails
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp

# Cambiar el usuario a rails para el resto de los comandos
USER rails

# Ejecutar cron como root para poder escribir en /var/run
USER root

# Asegurarse de que cron pueda escribir en /var/run
RUN mkdir -p /var/run/crond && chmod 755 /var/run/crond

# Create empty crontab file
#RUN crontab -l | { cat; echo ""; } | crontab -

# Update crontab file using whenever command
#RUN bundle exec whenever --update-crontab --set environment='production'

# Cambiar de nuevo a rails para ejecutar la aplicación
USER rails

# Entrypoint prepares the database.
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint
ENTRYPOINT ["docker-entrypoint"]

# Start the Rails server
ARG PORT
ENV PORT=${PORT}
EXPOSE ${PORT}

# CMD launches both the Rails server
CMD ["sh", "-c", "./bin/rails server"]
