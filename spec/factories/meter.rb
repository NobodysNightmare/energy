# frozen_string_literal: true
FactoryGirl.define do
  factory :meter do
    name { "#{Faker::Book.genre} #{Faker::Pokemon.name} #{rand(10_000)}" }
    serial { Faker::Code.imei }

    site
  end
end
