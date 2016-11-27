# frozen_string_literal: true
Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.production?
    provider :google_oauth2,
             ENV['GOOGLE_CLIENT_ID'],
             ENV['GOOGLE_CLIENT_SECRET'],
             name: 'google'
  else
    provider :developer
  end
end
