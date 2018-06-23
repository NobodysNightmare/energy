# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UnitHelper do
  let(:described_module) { Class.new { include UnitHelper } }

  describe 'format_watt' do
    let(:value) { 500 }
    subject { described_module.new.format_watt(value) }

    it 'renders a value as watts' do
      expect(subject).to eql('500.0 W')
    end

    context 'with a value above 1000 W' do
      let(:value) { 1001 }

      it 'renders the value as kilowatts' do
        expect(subject).to eql('1.0 kW')
      end
    end

    context 'with a value above 10000 W' do
      let(:value) { 12_400 }

      it 'renders the value as kilowatts' do
        expect(subject).to eql('12.4 kW')
      end
    end
  end

  describe 'format_watt_hours' do
    let(:value) { 500 }
    subject { described_module.new.format_watt_hours(value) }

    it 'renders a value as watt hours' do
      expect(subject).to eql('500.0 Wh')
    end

    context 'with a value above 1000 Wh' do
      let(:value) { 1001 }

      it 'renders the value as kilowatt hours' do
        expect(subject).to eql('1.0 kWh')
      end
    end

    context 'with a value above 10000 Wh' do
      let(:value) { 12_400 }

      it 'renders the value as kilowatt hours' do
        expect(subject).to eql('12.4 kWh')
      end
    end
  end

  describe 'format_watt_peak' do
    let(:value) { 500 }
    subject { described_module.new.format_watt_peak(value) }

    it 'renders a value as watt peak' do
      expect(subject).to eql('500.0 Wp')
    end

    context 'with a value above 1000 Wp' do
      let(:value) { 1001 }

      it 'renders the value as kilowatt peak' do
        expect(subject).to eql('1.0 kWp')
      end
    end

    context 'with a value above 10000 Wp' do
      let(:value) { 12_400 }

      it 'renders the value as kilowatt peak' do
        expect(subject).to eql('12.4 kWp')
      end
    end
  end
end
