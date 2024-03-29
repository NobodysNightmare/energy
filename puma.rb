# frozen_string_literal: true

threads 1, ENV.fetch('RAILS_MAX_THREADS', 5).to_i
workers ENV.fetch('PUMA_WORKER_COUNT', 0).to_i

environment ENV.fetch('RAILS_ENV', 'production')
