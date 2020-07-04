# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::MetersController do
  describe 'GET /api/meters/:serial/usage' do
    let(:meter) { FactoryBot.create(:meter, meter_type: :internal) }
    let(:rate) { FactoryBot.create :rate, site: meter.site }
    let(:serial) { meter.serial }
    let(:headers) { {} }
    let(:api_key) { ApiKey.create!(name: 'Test', secret: 'very-secret').secret }

    let(:query_params) { { from: from, to: to } }
    let(:from) { 5.minutes.ago.iso8601 }
    let(:to) { 0.minutes.ago.iso8601 }
    let(:imported) { 100 }
    let(:generated) { 80 }

    let(:response_json) { JSON.parse response.body }

    subject { get "/api/meters/#{serial}/usage", params: query_params, headers: headers }

    before do
      rate.save!

      FactoryBot.create :reading, meter: meter, time: from, value: 130
      FactoryBot.create :reading, meter: meter, time: to, value: 130 + imported + generated
      FactoryBot.create :energy_source_estimate, meter: meter, time: from, imported: 50, generated: 80
      FactoryBot.create :energy_source_estimate, meter: meter, time: to, imported: 50 + imported, generated: 80 + generated
    end

    context 'with a valid API Key' do
      let(:headers) { { 'Authorization' => "Bearer #{api_key}" } }

      it 'responds with HTTP 200 OK' do
        subject
        expect(response.status).to eql 200
      end

      it 'indicates the energy used' do
        subject
        expect(response_json.fetch('energy')).to eq(imported + generated)
      end

      it 'indicates the combined cost of import and generation' do
        subject
        expect(response_json.fetch('cost')).to eq(rate.import_rate * (imported / 1000.0) + (generated / 1000.0) * (rate.self_consume_rate + rate.export_rate))
      end

      context 'when meter does not support cost display' do
        let(:meter) { FactoryBot.create(:meter, meter_type: :generator) }

        it 'indicates cost as nil' do
          subject
          expect(response_json.fetch('cost')).to be_nil
        end
      end

      context 'when meter does not support energy source estimates' do
        let(:meter) { FactoryBot.create(:meter, meter_type: :grid_import) }

        before do
          EnergySourceEstimate.delete_all
        end

        it 'cost indication works based on import' do
          subject
          expect(response_json.fetch('cost')).to eq(rate.import_rate * ((imported + generated) / 1000.0))
        end
      end
    end

    context 'without a valid API Key' do
      let(:headers) { { 'Authorization' => 'Bearer invalid' } }

      it 'responds with HTTP 403 Forbidden' do
        subject
        expect(response.status).to eql 403
      end
    end
  end
end
