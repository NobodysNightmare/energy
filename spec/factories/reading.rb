# frozen_string_literal: true

FactoryBot.define do
  factory :reading do
    time Time.now
    sequence(:value) { |n| 1000 * n }
    meter
  end
end
