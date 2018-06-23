# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NeighbourFinder do
  subject { described_class.new(all_readings).readings_around(time) }

  let(:reading_1) { FactoryBot.build(:reading, time: Time.iso8601('2017-02-01T08:00:00Z')) }
  let(:reading_2) { FactoryBot.build(:reading, time: Time.iso8601('2017-02-01T09:00:00Z')) }
  let(:reading_3) { FactoryBot.build(:reading, time: Time.iso8601('2018-02-01T10:00:00Z')) }
  let(:reading_4) { FactoryBot.build(:reading, time: Time.iso8601('2018-02-01T11:00:00Z')) }
  let(:reading_5) { FactoryBot.build(:reading, time: Time.iso8601('2018-02-01T12:00:00Z')) }
  let(:all_readings) do
    [reading_1, reading_2, reading_3, reading_4, reading_5]
  end

  shared_examples_for 'between two readings' do
    let(:time) do
      duration = right_reading.time - left_reading.time
      left_reading.time + (duration / 2)
    end

    it 'returns both readings' do
      is_expected.to eql [left_reading, right_reading]
    end
  end

  context 'time is exactly on a reading' do
    %i[reading_1 reading_2 reading_3 reading_4 reading_5].each do |name|
      context name.to_s do
        let(:current_reading) { public_send(name) }
        let(:time) { current_reading.time }

        it 'has the reading in the result' do
          is_expected.to include current_reading
        end
      end
    end
  end

  context 'between 1 and 2' do
    let(:left_reading) { reading_1 }
    let(:right_reading) { reading_2 }

    it_behaves_like 'between two readings'
  end

  context 'between 2 and 3' do
    let(:left_reading) { reading_2 }
    let(:right_reading) { reading_3 }

    it_behaves_like 'between two readings'
  end

  context 'between 3 and 4' do
    let(:left_reading) { reading_3 }
    let(:right_reading) { reading_4 }

    it_behaves_like 'between two readings'
  end

  context 'between 4 and 5' do
    let(:left_reading) { reading_4 }
    let(:right_reading) { reading_5 }

    it_behaves_like 'between two readings'
  end
end
