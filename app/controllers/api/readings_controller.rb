# frozen_string_literal: true
module Api
  class ReadingsController < ApiController
    def create
      ActiveRecord::Base.transaction do
        readings.each do |reading_hash|
          reading = build_reading(reading_hash)

          # We already have it, but a validation error
          # is not neccessary (since everything is equal)
          next if exact_duplicate?(reading)

          reading.save!
        end
      end

      render json: { message: 'Readings were created' }, status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.message }, status: :bad_request
    end

    private

    def meter
      @meter ||= Meter.find_by!(serial: params[:meter_serial])
    end

    def readings
      params[:readings]
    end

    def build_reading(reading_hash)
      Reading.new(
        meter: meter,
        time: Time.iso8601(reading_hash[:time]),
        value: reading_hash[:value]
      )
    end

    def exact_duplicate?(reading)
      meter.readings
           .where(
             time: reading.time,
             value: reading.value
           ).exists?
    end
  end
end
