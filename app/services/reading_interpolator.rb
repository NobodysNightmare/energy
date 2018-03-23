# frozen_string_literal: true

class ReadingInterpolator
  def initialize(readings, from:, to:)
    @unscoped_readings = readings
    @from = from
    @to = to
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
    # TODO: more efficient search using binary search
    before = readings.reverse.find { |r| r.time <= time }
    after = readings.find { |r| r.time >= time }

    estimate(before.value, rate(before, after), time - before.time)
  end

  def extrapolate(time)
    if time < first_reading.time
      extrapolate_before(time)
    elsif time > last_reading.time
      extrapolate_after(time)
    else
      raise ArgumentError, 'Time is not outside of readings range.'
    end
  end

  def extrapolate_before(time)
    estimate(first_reading.value, -1 * rate(readings[0], readings[1]), first_reading.time - time)
  end

  def extrapolate_after(time)
    estimate(last_reading.value, rate(readings[-2], readings[-1]), time - last_reading.time)
  end

  def estimate(base_value, rate, progress)
    base_value + (progress * rate)
  end

  def rate(from, to)
    return 0 if from.time == to.time
    (to.value - from.value) / (to.time - from.time)
  end
end
