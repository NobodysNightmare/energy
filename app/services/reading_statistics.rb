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
      if now && before
        time_passed = now.time - before.time
        generated = now.value - before.value

        generated * (1.hour / time_passed)
      else
        0.0
      end
    end
  end

  def total_generation
    @total_generation ||= begin
      period_readings = readings.where('time > ? AND time < ?', @from, @to).order(:time)
      first_reading = period_readings.first
      last_reading = period_readings.last

      if first_reading && last_reading
        last_reading.value - first_reading.value
      else
        0
      end
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
end
