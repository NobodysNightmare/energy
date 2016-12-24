# frozen_string_literal: true
FactoryGirl.define do
  factory :inverter do
    capacity { 6000 + (rand(50) * 100) }
    name { "#{Faker::Book.genre} #{Faker::Pokemon.name}" }
    serial { Faker::Code.imei }
  end
end
