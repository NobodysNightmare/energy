# frozen_string_literal: true

FactoryBot.define do
  factory :energy_source_estimate do
    time { Time.now }
    sequence(:generated) { |n| 1200 * n }
    sequence(:imported) { |n| 800 * n }
    meter
  end
end
