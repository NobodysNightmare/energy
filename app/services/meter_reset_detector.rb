# frozen_string_literal: true

class MeterResetDetector
  attr_reader :meter

  def initialize(meter, batch_size: 1000)
    @meter = meter
    @batch_size = batch_size
  end

  def each_reset
    last_reading = all_readings.first

    each_reading_in_batches do |reading|
      yield reading, last_reading if reading.raw_value < last_reading.raw_value
      last_reading = reading
    end
  end

  def fix_resets
    reset_from = 0
    reset_to = 0
    each_reset do |reading, prev_reading|
      reset_from += prev_reading.raw_value - reset_to
      reset_to = reading.raw_value

      offset = reset_from - reset_to
      all_readings.where(time: reading.time..).update_all("value = raw_value + #{offset}")
    end

    meter.update!(reset_from:, reset_to:)
    EnergySourceEstimator.new(meter).reestimate_all if meter.internal?
  end

  private

  def all_readings
    meter.readings.order(time: :asc)
  end

  def each_reading_in_batches(&block)
    offset = 0
    loop do
      batch = all_readings.offset(offset).limit(@batch_size).to_a
      break if batch.empty?

      batch.each(&block)
      offset += @batch_size
    end
  end
end
