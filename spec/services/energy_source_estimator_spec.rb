# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EnergySourceEstimator do
  let(:meter) { FactoryBot.create :meter }
  let(:site_stats) { instance_double(SiteStatistics, generators: generators, imports: imports, exports: exports) }
  let(:generators) { instance_double(ReadingStatistics, energy_between: generated) }
  let(:imports) { instance_double(ReadingStatistics, energy_between: imported) }
  let(:exports) { instance_double(ReadingStatistics, energy_between: exported) }
  let(:generated) { 1000 }
  let(:imported) { 1000 }
  let(:exported) { 0 }

  let(:latest) { 5.minutes.ago }
  let(:readings) do
    [
      FactoryBot.create(:reading, meter: meter, time: latest - 30.minutes, value: 1000),
      FactoryBot.create(:reading, meter: meter, time: latest, value: 2000)
    ]
  end

  before do
    allow(SiteStatistics).to receive(:new).and_return(site_stats)
    readings.each(&:save!)
  end

  describe '#append_estimates' do
    subject { described_class.new(meter).append_estimates }

    it 'adds estimates at the time of readings' do
      subject
      expect(EnergySourceEstimate.all.map(&:time)).to eq(readings.drop(1).map(&:time))
    end

    context 'when estimates have already been performed for same readings' do
      before do
        described_class.new(meter).append_estimates
      end

      it 'does not add additional estimates' do
        expect { subject }.not_to change { EnergySourceEstimate.count }
      end
    end

    context 'when readings come in quicker than slowest meter duration' do
      let(:readings) do
        [
          FactoryBot.create(:reading, meter: meter, time: latest - 15.minutes, value: 500),
          FactoryBot.create(:reading, meter: meter, time: latest - 5.minutes, value: 1000),
          FactoryBot.create(:reading, meter: meter, time: latest, value: 1500)
        ]
      end

      before do
        FactoryBot.create :meter, site: meter.site, current_duration: 900
      end

      it 'only creates estimates according to slowest meter' do
        subject

        expected_readings = [readings.last]
        expect(EnergySourceEstimate.all.map(&:time)).to eq(expected_readings.map(&:time))
      end

      it 'calculates total energy using first and last reading' do
        subject
        expect(EnergySourceEstimate.last.total).to eq 1000
      end
    end

    context 'when latest reading is too new' do
      let(:latest) { Time.zone.now }

      it 'does not create a new estimate for that reading' do
        subject
        expect(EnergySourceEstimate.count).to be_zero
      end
    end

    context 'when site only consumes generated energy' do
      let(:generated) { 2000 }
      let(:imported) { 0 }

      it 'does not estimate any import' do
        subject
        expect(EnergySourceEstimate.last.imported). to eq 0
      end

      it 'estimates energy from generator equal to reading increase' do
        subject
        expect(EnergySourceEstimate.last.generated). to eq 1000
      end
    end

    context 'when site only consumes imported energy' do
      let(:generated) { 0 }
      let(:imported) { 2000 }

      it 'does not estimate any generation' do
        subject
        expect(EnergySourceEstimate.last.generated). to eq 0
      end

      it 'estimates energy from import equal to reading increase' do
        subject
        expect(EnergySourceEstimate.last.imported). to eq 1000
      end
    end

    context 'when site consumes a mix of energies' do
      let(:generated) { 2000 }
      let(:imported) { 2000 }

      it 'estimates proportional amount from generation' do
        subject
        expect(EnergySourceEstimate.last.generated). to eq 500
      end

      it 'estimates proportional amount from import' do
        subject
        expect(EnergySourceEstimate.last.imported). to eq 500
      end

      context 'and when energy cannot be cleanly split' do
        let(:readings) do
          [
            FactoryBot.create(:reading, meter: meter, time: latest - 30.minutes, value: 0),
            FactoryBot.create(:reading, meter: meter, time: latest, value: 5)
          ]
        end

        it 'has the same total energy as the original reading' do
          subject
          expect(EnergySourceEstimate.last.total). to eq 5
        end
      end

      context 'and when export is happening at the same time' do
        let(:exported) { 1500 } # 2000 (gen) - 1500 (ex) = 500 (used gen)

        it 'estimates generation proportional to usable generation' do
          subject
          expect(EnergySourceEstimate.last.generated). to eq 200
        end

        it 'estimates import proportional to usable generation' do
          subject
          expect(EnergySourceEstimate.last.imported). to eq 800
        end
      end

      context 'and when export outweighs generation' do
        # can mostly happen due to differences in meter resolution
        let(:exported) { 3000 }

        it 'estimates generation of 0%' do
          subject
          expect(EnergySourceEstimate.last.generated). to eq 0
        end

        it 'estimates import of 100%' do
          subject
          expect(EnergySourceEstimate.last.imported). to eq 1000
        end
      end
    end

    context 'when multiple estimates are created' do
      let(:readings) do
        [
          FactoryBot.create(:reading, meter: meter, time: latest - 60.minutes, value: 0),
          FactoryBot.create(:reading, meter: meter, time: latest - 30.minutes, value: 1000),
          FactoryBot.create(:reading, meter: meter, time: latest, value: 2000)
        ]
      end

      it 'creates the first estimate starting at 0' do
        subject
        expect(EnergySourceEstimate.first.generated).to eq 500
      end

      it 'adds up readings for subsequent estimates (estimates reflect total values)' do
        subject
        expect(EnergySourceEstimate.last.generated).to eq 1000
      end
    end

    context 'when there is already an estimate' do
      before do
        FactoryBot.create(:energy_source_estimate, meter: meter, time: latest - 60.minutes, generated: 2500, imported: 3500)
      end

      it 'adds up generation value to existing estimate' do
        subject
        expect(EnergySourceEstimate.last.generated).to eq 3000
      end

      it 'adds up import value to existing estimate' do
        subject
        expect(EnergySourceEstimate.last.imported).to eq 4000
      end
    end
  end
end
