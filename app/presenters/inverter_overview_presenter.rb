# frozen_string_literal: true
class InverterOverviewPresenter < SimpleDelegator
  def current_power
    @current_power ||= begin
      now, before = inverter_readings.order(time: :desc).limit(2).to_a
      if now && before
        time_passed = now.time - before.time
        generated = now.value - before.value

        generated * (1.hour / time_passed)
      else
        0
      end
    end
  end

  def latest_reading
    @latest_reading ||= inverter_readings.order(:time).last
  end
end
