# frozen_string_literal: true
class InverterOverviewPresenter < SimpleDelegator
  def current_power
    @current_power ||= begin
      before, now = latest_cycle
      if now && before
        time_passed = now.time - before.time
        generated = now.value - before.value

        generated * (1.hour / time_passed)
      else
        0
      end
    end
  end

  def daily_generation
    @daily_generation ||= begin
      day_start = inverter_readings.where('time > ?', Date.today.to_time)
                                   .order(:time)
                                   .first
      if day_start
        latest_reading.value - day_start.value
      else
        0
      end
    end
  end

  def latest_reading
    latest_cycle.last
  end

  def latest_cycle
    @latest_cycle ||= inverter_readings.order(time: :desc)
                                       .limit(2)
                                       .to_a
                                       .reverse
  end
end
