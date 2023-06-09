# frozen_string_literal: true

class AddReadings
  def initialize(meter)
    @meter = meter
  end

  def add(reading_params)
    reading = build_reading(reading_params)

    valid = reading.save
    if valid
      update_estimates
      ReadingUpdateAnnouncer.announce(reading)
    end

    [valid, reading]
  end

  private

  def build_reading(reading_params)
    Reading.new(
      meter: @meter,
      time: Time.zone.iso8601(reading_params[:time]),
      raw_value: reading_params[:value],
      value: offset(reading_params[:value])
    )
  end

  def offset(value)
    value = Integer(value)
    @meter.reset_from + value - @meter.reset_to
  end

  def update_estimates
    return unless @meter.internal?

    EnergySourceEstimator.new(@meter).append_estimates
  end
end
