# frozen_string_literal: true
FactoryGirl.define do
  factory :site do
    name { "#{Faker::Book.genre} #{Faker::Pokemon.name}" }
  end
end
