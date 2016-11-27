# frozen_string_literal: true
namespace :users do
  desc 'Lists all existing Users'
  task list: :environment do
    users = User.all.to_a
    users.each do |user|
      active = user.active? ? '✓' : '✗'
      puts "#{active} #{user.user_id}: #{user.name} (#{user.email})"
    end
  end

  desc 'Activates the given user (by user_id)'
  task :activate, [:user_id] => :environment do |_, args|
    User.find_by(user_id: args[:user_id])
        .update_attributes!(active: true)
  end

  desc 'Activates the given user (by user_id)'
  task :deactivate, [:user_id] => :environment do |_, args|
    User.find_by(user_id: args[:user_id])
        .update_attributes!(active: false)
  end
end
