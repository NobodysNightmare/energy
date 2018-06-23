# frozen_string_literal: true

FactoryBot.define do
  factory :site do
    name { "#{Faker::Book.genre} #{Faker::Pokemon.name} #{rand(10_000)}" }
  end
end
