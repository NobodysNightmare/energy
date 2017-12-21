# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::ReadingsController do
  describe 'POST readings' do
    let(:inverter) { FactoryGirl.create(:inverter) }
    let(:serial) { inverter.serial }
    let(:time) { Time.now.change(usec: 0) }
    let(:value) { 1337 }
    let(:readings) { [{ time: time.iso8601, value: value }] }

    subject { process :create, method: :post, params: { inverter_serial: serial, readings: readings } }

    context 'with a valid API Key' do
      before do
        allow(controller).to receive(:check_api_key)
      end

      it 'responds with HTTP 201 Created' do
        subject
        expect(response.status).to eql 201
      end

      it 'creates a reading' do
        expect { subject }.to change { Reading.count }.from(0).to(1)
      end

      it 'creates a reading for the given inverter' do
        subject
        expect(Reading.first.inverter).to eql inverter
      end

      it 'creates a reading with the given value' do
        subject
        expect(Reading.first.value).to eql value
      end

      it 'creates a reading for the given time' do
        subject
        expect(Reading.first.time).to eql time
      end

      context 'reading with same values for different inverter' do
        before do
          Reading.create!(inverter: FactoryGirl.create(:inverter),
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
          Reading.create!(inverter: inverter,
                                  time: time,
                                  value: value * 2)
        end

        it 'responds with HTTP 400 Bad Request' do
          subject
          expect(response.status).to eql 400
        end

        it 'creates a reading' do
          expect { subject }.not_to change { Reading.count }
        end
      end

      context 'reading with same time and same value' do
        before do
          Reading.create!(inverter: inverter,
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
  end
end
