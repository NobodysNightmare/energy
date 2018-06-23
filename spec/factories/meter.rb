# frozen_string_literal: true

FactoryBot.define do
  factory :meter do
    name { "#{Faker::Book.genre} #{Faker::Pokemon.name} #{rand(10_000)}" }
    serial { Faker::Code.imei }

    site
  end
end
