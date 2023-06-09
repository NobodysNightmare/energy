# frozen_string_literal: true

FactoryBot.define do
  factory :meter do
    name { "#{Faker::Book.genre} #{Faker::Games::Pokemon.name} #{rand(10_000)}" }
    serial { Faker::Code.imei }
    current_duration { 300 }

    site
  end
end
