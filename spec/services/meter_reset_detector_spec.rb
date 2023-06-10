# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MeterResetDetector do
  MAPPING_TESTS = {
    [1, 2, 3, 4, 5] => [1, 2, 3, 4, 5],
    [1, 2, 3, 1, 2, 3] => [1, 2, 3, 3, 4, 5],
    [1, 2, 3, 1, 2, 3, 1, 2, 3] => [1, 2, 3, 3, 4, 5, 5, 6, 7],
    [100, 101, 102, 1, 2, 3] => [100, 101, 102, 102, 103, 104],
    [100, 101, 102, 10, 11, 12] => [100, 101, 102, 102, 103, 104],
    [100, 101, 102, 10, 11, 12, 1, 2, 3] => [100, 101, 102, 102, 103, 104, 104, 105, 106]
  }

  describe 'mapping tests' do
    # using extra small batch size to test custom batching implementation
    subject { described_class.new(meter, batch_size: 2).fix_resets; actual_values }
    let(:meter) { FactoryBot.create(:meter) }

    let(:actual_values) { meter.readings.order(time: :asc).pluck(:value) }

    MAPPING_TESTS.each do |raw_values, expected_values|
      context "when raw values are #{raw_values.inspect}" do
        before do
          raw_values.each.with_index do |raw, i|
            Reading.create!(meter:, time: i.minutes.from_now, value: raw, raw_value: raw)
          end
        end

        it { is_expected.to eq(expected_values) }
      end

      context "when raw values are #{raw_values.inspect}, but stored out-of-order" do
        before do
          raw_values.each_with_index.to_a.shuffle.each do |raw, i|
            Reading.create!(meter:, time: i.minutes.from_now, value: raw, raw_value: raw)
          end
        end

        it { is_expected.to eq(expected_values) }
      end
    end
  end
end
