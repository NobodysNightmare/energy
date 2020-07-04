# frozen_string_literal: true

class Interpolator
  def initialize(readings, from:, to:, value_accessor: :value)
    @unscoped_readings = readings
    @from = from
    @to = to
    @value_accessor = value_accessor
  end

  def value_at(time)
    return nil if readings.empty?

    if first_reading.time <= time && time <= last_reading.time
      interpolate(time)
    else
      extrapolate(time)
    end
  end

  def readings
    @readings ||= ContextFetcher.new(@unscoped_readings)
                                .fetch(@from, @to)
                                .to_a
  end

  def first_reading
    readings.first
  end

  def last_reading
    readings.last
  end

  private

  def interpolate(time)
    finder = NeighbourFinder.new(readings)
    before, after = finder.readings_around(time)

    estimate(value(before), rate(before, after), time - before.time)
  end

  def extrapolate(time)
    if time < first_reading.time
      value(first_reading)
    elsif time > last_reading.time
      value(last_reading)
    else
      raise ArgumentError, 'Time is not outside of readings range.'
    end
  end

  def estimate(base_value, rate, progress)
    base_value + (progress * rate)
  end

  def rate(from, to)
    return 0 if from.time == to.time
    (value(to) - value(from)) / (to.time - from.time)
  end

  def value(record)
    record.public_send(@value_accessor)
  end
end
