# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BatterySimulation::Battery do
  let(:capacity) { 3_000 }
  let(:charge_power) { 1_000 }
  let(:discharge_power) { 1_000 }
  let(:charge_efficiency) { 0.8 }

  subject(:battery) { described_class.new(capacity, charge_power, discharge_power, charge_efficiency) }

  it 'starts at a charge of 0 Wh' do
    expect(battery.current_charge).to be_zero
  end

  describe '#charge' do
    let(:initial_charge) { 500 }
    let(:energy) { 100 }
    let(:duration) { 1.day }

    before do
      battery.current_charge = initial_charge
    end

    it 'adds the desired energy to the current charge, considering efficiency' do
      battery.charge(energy, duration: duration)
      expect(battery.current_charge).to eq 580
    end

    it 'returns the amount of charged energy' do
      charged, _ = battery.charge(energy, duration: duration)
      expect(charged).to eq 80
    end

    it 'returns the amount of consumed energy' do
      _, consumed = battery.charge(energy, duration: duration)
      expect(consumed).to eq 100
    end

    context 'when trying to overcharge' do
      let(:energy) { 5_000 }

      it 'caps the current charge to the capacity' do
        battery.charge(energy, duration: duration)
        expect(battery.current_charge).to eq battery.capacity
      end

      it 'returns the amount of charged energy' do
        charged, _ = battery.charge(energy, duration: duration)
        expect(charged).to eq 2_500
      end

      it 'returns the amount of consumed energy' do
        _, consumed = battery.charge(energy, duration: duration)
        expect(consumed).to eq 3_125
      end
    end

    context 'when trying to charge too quickly' do
      let(:energy) { 2 * charge_power }
      let(:duration) { 1.hour }

      it 'caps the charged energy according to power constraints' do
        battery.charge(energy, duration: duration)
        expect(battery.current_charge).to eq (initial_charge + charge_power * charge_efficiency)
      end

      it 'returns the amount of charged energy' do
        charged, _ = battery.charge(energy, duration: duration)
        expect(charged).to eq charge_power * charge_efficiency
      end

      it 'returns the amount of consumed energy' do
        _, consumed = battery.charge(energy, duration: duration)
        expect(consumed).to eq charge_power
      end
    end

    context 'when charging nothing' do
      let(:energy) { 0 }

      it 'adds nothing to the current charge' do
        battery.charge(energy, duration: duration)
        expect(battery.current_charge).to eq 500
      end

      it 'returns the amount of charged energy' do
        charged, _ = battery.charge(energy, duration: duration)
        expect(charged).to eq 0
      end

      it 'returns the amount of consumed energy' do
        _, consumed = battery.charge(energy, duration: duration)
        expect(consumed).to eq 0
      end
    end
  end

  describe '#discharge' do
    let(:initital_charge) { 1500 }
    let(:energy) { 100 }
    let(:duration) { 1.day }

    before do
      battery.current_charge = initital_charge
    end

    it 'removes the desired energy from the current charge' do
      battery.discharge(energy, duration: duration)
      expect(battery.current_charge).to eq 1400
    end

    it 'returns the amount of discharged energy' do
      discharged = battery.discharge(energy, duration: duration)
      expect(discharged).to eq 100
    end

    context 'when trying to discharge below zero' do
      let(:energy) { 5_000 }

      it 'caps the current charge to zero' do
        battery.discharge(energy, duration: duration)
        expect(battery.current_charge).to be_zero
      end

      it 'returns the amount of discharged energy' do
        discharged = battery.discharge(energy, duration: duration)
        expect(discharged).to eq 1_500
      end
    end

    context 'when trying to discharge too quickly' do
      let(:energy) { 2 * discharge_power }
      let(:duration) { 1.hour }

      it 'caps the discharged energy according to power constraints' do
        battery.discharge(energy, duration: duration)
        expect(battery.current_charge).to eq (initital_charge - discharge_power)
      end

      it 'returns the amount of discharged energy' do
        discharged = battery.discharge(energy, duration: duration)
        expect(discharged).to eq discharge_power
      end
    end
  end
end
