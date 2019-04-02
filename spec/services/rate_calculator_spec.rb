# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RateCalculator do
  subject { described_class.new(rates, rate_type, statistics).cost_between(from, to) }

  let(:rates) do
    [
      FactoryBot.build(:rate, valid_from: Date.iso8601('2019-01-01'), import_rate: 10),
      FactoryBot.build(:rate, valid_from: Date.iso8601('2019-02-01'), import_rate: 20),
      FactoryBot.build(:rate, valid_from: Date.iso8601('2019-03-01'), import_rate: 30)
    ]
  end
  let(:rate_type) { :import_rate }
  let(:statistics) { double(ReadingStatistics, energy_between: 10_000) }
  let(:from) { Date.iso8601('2019-04-01') }
  let(:to) { Date.iso8601('2019-05-01') }

  context 'when range is before any rate' do
    let(:from) { Date.iso8601('2018-12-01') }
    let(:to) { Date.iso8601('2019-01-01') }

    it('calculates no cost') { is_expected.to eq 0 }
  end

  context 'when range is after all rates' do
    let(:from) { Date.iso8601('2019-04-01') }
    let(:to) { Date.iso8601('2019-05-01') }

    it('assumes last rate') { is_expected.to eq 300 }

    it 'queries the correct edge dates' do
      expect(statistics).to receive(:energy_between).with(from, to)
      subject
    end

    context 'when rate_type is given as lambda' do
      let(:rate_type) { ->(r) { 40 } }

      it('assumes value from lambda') { is_expected.to eq 400 }

      it 'passes the current rate into the lambda' do
        expect(rate_type).to receive(:call).with(rates.last).and_call_original
        subject
      end
    end
  end

  context 'when range exactly covers first rate' do
    let(:from) { Date.iso8601('2019-01-01') }
    let(:to) { Date.iso8601('2019-02-01') }

    it('assumes first rate') { is_expected.to eq 100 }

    it 'queries the correct edge dates' do
      expect(statistics).to receive(:energy_between).with(from, to)
      subject
    end
  end

  context 'when range exactly covers two rates' do
    let(:from) { Date.iso8601('2019-01-15') }
    let(:to) { Date.iso8601('2019-02-15') }

    it('uses both rates') { is_expected.to eq 300 }

    it 'queries the correct edge dates' do
      mid_date = Date.iso8601('2019-02-01')
      expect(statistics).to receive(:energy_between).with(from, mid_date).ordered
      expect(statistics).to receive(:energy_between).with(mid_date, to).ordered
      subject
    end
  end

  context 'when range covers everything' do
    let(:from) { Date.iso8601('2018-12-01') }
    let(:to) { Date.iso8601('2019-04-01') }

    it('calculates cost with all rates') { is_expected.to eq 600 }

    it 'queries the correct edge dates' do
      expect(statistics).to receive(:energy_between).with(rates.first.valid_from, rates.second.valid_from).ordered
      expect(statistics).to receive(:energy_between).with(rates.second.valid_from, rates.last.valid_from).ordered
      expect(statistics).to receive(:energy_between).with(rates.last.valid_from, to).ordered
      subject
    end
  end

  context 'when there are no rates' do
    let(:rates) { [] }

    it('calculates no cost') { is_expected.to eq 0 }
  end
end
