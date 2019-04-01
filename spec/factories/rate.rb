# frozen_string_literal: true

FactoryBot.define do
  factory :rate do
    valid_from Date.today
    import_rate 20
    export_rate 10
    self_consume_rate 5

    site
  end
end
