# frozen_string_literal: true

namespace :api_keys do
  desc 'Lists all existing API-Keys'
  task list: :environment do
    keys = ApiKey.all.to_a
    puts "There are #{keys.size} Keys granting access to the API."
    keys.each do |api_key|
      puts "#{api_key.name}, created #{api_key.created_at.iso8601}"
    end
  end

  desc 'Generates a new API-Key'
  task :create, [:name] => :environment do |_, args|
    name = args[:name]
    secret = SecureRandom.base64(32)
    ApiKey.create!(name: name, secret: secret)
    puts "Created API-Key named #{name}."
    puts "Secret: #{secret}"
  end

  desc 'Revokes the specified API-Key'
  task :revoke, [:name] => :environment do |_, args|
    name = args[:name]
    key = ApiKey.find_by(name: name)
    key.destroy
    puts "Revoked API-Key named #{name}."
  end
end
