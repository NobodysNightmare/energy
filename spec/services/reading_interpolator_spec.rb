# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReadingInterpolator do
  let(:interpolator) do
    described_class.new(
      Reading,
      from: Time.iso8601('2018-01-01T00:00:00Z'),
      to: Time.iso8601('2018-01-02T00:00:00Z')
    )
  end

  describe '#readings' do
    subject(:readings) { interpolator.readings }

    let(:reading_before) { FactoryBot.build(:reading, time: Time.iso8601('2017-12-01T10:00:00Z')) }
    let(:additional_reading_before) { FactoryBot.build(:reading, time: Time.iso8601('2017-12-01T09:00:00Z')) }
    let(:reading_after) { FactoryBot.build(:reading, time: Time.iso8601('2018-02-01T10:00:00Z')) }
    let(:additional_reading_after) { FactoryBot.build(:reading, time: Time.iso8601('2018-02-01T11:00:00Z')) }
    let(:reading_inside) { FactoryBot.build(:reading, time: Time.iso8601('2018-01-01T10:00:00Z')) }
    let(:all_readings) do
      [
        reading_before,
        reading_after,
        reading_inside,
        additional_reading_before,
        additional_reading_after
      ]
    end

    before do
      all_readings.each(&:save!)
    end

    it 'includes the reading inside the timeframe' do
      is_expected.to include(reading_inside)
    end

    it 'includes the reading right before the timeframe' do
      is_expected.to include(reading_before)
    end

    it 'includes the reading right after the timeframe' do
      is_expected.to include(reading_after)
    end

    it ' does not include a second reading before the timeframe' do
      is_expected.not_to include(additional_reading_before)
    end

    it ' does not include a second reading after the timeframe' do
      is_expected.not_to include(additional_reading_after)
    end
  end

  describe '#value_at' do
    subject(:result) { interpolator.value_at(time) }

    let(:time) { nil }
    let(:reading_a) { FactoryBot.build(:reading, time: Time.iso8601('2018-01-01T10:00:00Z'), value: 1000) }
    let(:reading_b) { FactoryBot.build(:reading, time: Time.iso8601('2018-01-01T12:00:00Z'), value: 2000) }
    let(:all_readings) { [reading_a, reading_b] }

    before do
      all_readings.each(&:save!)
    end

    context 'when interpolating in the center' do
      let(:time) { Time.iso8601('2018-01-01T11:00:00Z') }

      it 'returns the average value' do
        is_expected.to eq((reading_a.value + reading_b.value) / 2)
      end
    end

    context 'when interpolating at the start' do
      let(:time) { Time.iso8601('2018-01-01T10:00:00Z') }

      it 'returns the start value' do
        is_expected.to eq reading_a.value
      end
    end

    context 'when interpolating at the end' do
      let(:time) { Time.iso8601('2018-01-01T12:00:00Z') }

      it 'returns the end value' do
        is_expected.to eq reading_b.value
      end
    end

    context 'when interpolating before the start' do
      let(:time) { Time.iso8601('2018-01-01T09:00:00Z') }

      it 'returns the start value' do
        is_expected.to eq reading_a.value
      end
    end

    context 'when interpolating after the end' do
      let(:time) { Time.iso8601('2018-01-01T13:00:00Z') }

      it 'returns the end value' do
        is_expected.to eq reading_b.value
      end
    end

    context 'when there is only one reading' do
      let(:all_readings) { [reading_a] }

      context 'and the time is on that reading' do
        let(:time) { reading_a.time }

        it 'returns that reading\'s value' do
          is_expected.to eq reading_a.value
        end
      end

      context 'and the time is different' do
        let(:time) { Time.iso8601('2018-01-01T13:00:00Z') }

        it 'returns the only known value' do
          is_expected.to eq reading_a.value
        end
      end
    end

    context 'when there are no readings' do
      let(:all_readings) { [] }
      let(:time) { Time.iso8601('2018-01-01T13:00:00Z') }

      it 'returns nil' do
        is_expected.to be_nil
      end
    end
  end
end
