# frozen_string_literal: true

class ReadingStatistics
  attr_reader :readings

  def initialize(readings, from:, to:, current_duration: 5.minutes)
    @readings = readings
    @from = from
    @to = to
    @current_duration = current_duration
  end

  def current_power
    @current_power ||= begin
      now = latest_reading
      if now && now.time > @from
        generated = energy_between(now.time - @current_duration, now.time)
        generated * (1.hour / @current_duration)
      else
        0.0
      end
    end
  end

  def total_energy
    energy_between(@from, @to)
  end

  def energy_between(from, to)
    first_value = interpolator.value_at(from)
    last_value = interpolator.value_at(to)

    if first_value && last_value
      last_value - first_value
    else
      0
    end
  end

  def latest_reading
    @latest_reading ||= readings.order(time: :asc).last
  end

  private

  def interpolator
    @interpolator ||= ReadingInterpolator.new(readings, from: @from, to: @to)
  end
end
