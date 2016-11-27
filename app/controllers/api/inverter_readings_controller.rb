# frozen_string_literal: true
module Api
  class InverterReadingsController < ApiController
    def create
      ActiveRecord::Base.transaction do
        readings.each do |reading|
          InverterReading.create!(
            inverter: inverter,
            time: Time.iso8601(reading[:time]),
            value: reading[:value]
          )
        end
      end

      render json: { message: 'Readings were created' }, status: :created
    end

    private

    def inverter
      @inverter ||= Inverter.find_by!(serial: params[:inverter_serial])
    end

    def readings
      params[:readings]
    end
  end
end
