# frozen_string_literal: true

class ReadingStatistics
  attr_reader :readings

  def initialize(readings, from:, to:)
    @readings = readings
    @from = from
    @to = to
  end

  def current_power
    @current_power ||= begin
      before, now = latest_cycle
      if now && before && now.time > @from
        time_passed = now.time - before.time
        generated = now.value - before.value

        generated * (1.hour / time_passed)
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
    latest_cycle.last
  end

  private

  def latest_cycle
    @latest_cycle ||= readings.order(time: :desc)
                              .limit(2)
                              .reverse
  end

  def interpolator
    @interpolator ||= ReadingInterpolator.new(readings, from: @from, to: @to)
  end
end
