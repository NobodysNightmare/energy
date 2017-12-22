# frozen_string_literal: true
FactoryGirl.define do
  factory :meter do
    name { "#{Faker::Book.genre} #{Faker::Pokemon.name}" }
    serial { Faker::Code.imei }
  end
end
