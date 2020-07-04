# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::ReadingsController do
  describe 'POST /api/meters/:serial/readings' do
    let(:meter) { FactoryBot.create(:meter) }
    let(:serial) { meter.serial }
    let(:time) { Time.now.change(usec: 0) }
    let(:value) { 1337 }
    let(:readings) { [{ time: time.iso8601, value: value }] }
    let(:headers) { {} }
    let(:api_key) { ApiKey.create!(name: 'Test', secret: 'very-secret').secret }

    subject { post "/api/meters/#{serial}/readings", params: { readings: readings }, headers: headers }

    before do
      allow(ReadingUpdateAnnouncer).to receive(:announce).and_return(nil)
    end

    context 'with a valid API Key' do
      let(:headers) { { 'Authorization' => "Bearer #{api_key}" } }

      it 'responds with HTTP 201 Created' do
        subject
        expect(response.status).to eql 201
      end

      it 'creates a reading' do
        expect { subject }.to change { Reading.count }.from(0).to(1)
      end

      it 'creates a reading for the given meter' do
        subject
        expect(Reading.first.meter).to eql meter
      end

      it 'creates a reading with the given value' do
        subject
        expect(Reading.first.value).to eql value
      end

      it 'creates a reading for the given time' do
        subject
        expect(Reading.first.time).to eql time
      end

      it 'Announces the new reading to graphite' do
        expect(ReadingUpdateAnnouncer).to receive(:announce)
        subject
      end

      context 'reading with same values for different meter' do
        before do
          Reading.create!(meter: FactoryBot.create(:meter),
                          time: time,
                          value: value)
        end

        it 'responds with HTTP 201 Created' do
          subject
          expect(response.status).to eql 201
        end

        it 'creates a reading' do
          expect { subject }.to change { Reading.count }.from(1).to(2)
        end
      end

      context 'reading with same time and different value' do
        before do
          Reading.create!(meter: meter,
                          time: time,
                          value: value * 2)
        end

        it 'responds with HTTP 400 Bad Request' do
          subject
          expect(response.status).to eql 400
        end

        it 'does not create a reading' do
          expect { subject }.not_to change { Reading.count }
        end
      end

      context 'reading with same time and same value' do
        before do
          Reading.create!(meter: meter,
                          time: time,
                          value: value)
        end

        it 'responds with HTTP 201 Created' do
          subject
          expect(response.status).to eql 201
        end

        it 'creates no reading' do
          expect { subject }.not_to change { Reading.count }
        end
      end
    end

    context 'without a valid API Key' do
      let(:headers) { { 'Authorization' => 'Bearer invalid' } }

      it 'responds with HTTP 403 Forbidden' do
        subject
        expect(response.status).to eql 403
      end

      it 'does not create a reading' do
        expect { subject }.not_to change { Reading.count }
      end
    end
  end
end
