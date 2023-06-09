FROM ruby:3.2

WORKDIR /app
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["puma", "--config", "puma.rb", "-p", "3000"]
ENV RAILS_LOG_TO_STDOUT=true RAILS_SERVE_STATIC_FILES=true

RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs && \
    npm install --global yarn

ADD Gemfile Gemfile.lock ./
RUN bundle install --jobs 5

COPY . ./

RUN yarn
RUN rake assets:precompile
