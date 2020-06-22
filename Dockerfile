FROM ruby:2.6

WORKDIR /app
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["puma", "--config", "puma.rb", "-p", "3000"]
ENV RAILS_LOG_TO_STDOUT=true RAILS_SERVE_STATIC_FILES=true

ADD Gemfile Gemfile.lock ./
RUN bundle install --jobs 5 --frozen

COPY . ./
RUN rake assets:precompile
