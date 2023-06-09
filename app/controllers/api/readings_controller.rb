# frozen_string_literal: true

module Api
  class ReadingsController < ApiController
    def create
      add_srv = AddReadings.new(meter)
      error = nil

      ActiveRecord::Base.transaction do
        readings.each do |reading_hash|
          valid, reading = add_srv.add(reading_hash)

          next if valid

          # We already have it, but a validation error
          # is not neccessary (since everything is equal)
          next if exact_duplicate?(reading)

          error = reading.errors.full_messages.to_sentence
          raise ActiveRecord::Rollback
        end
      end

      if error
        render json: { error: }, status: :bad_request
      else
        render json: { message: 'Readings were created' }, status: :created
      end
    end

    private

    def meter
      @meter ||= Meter.find_by!(serial: serial_param)
    end

    def serial_param
      params[:meter_serial].presence || params[:inverter_serial]
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

    def update_estimates
      return unless meter.internal?

      EnergySourceEstimator.new(meter).append_estimates
    end
  end
end
