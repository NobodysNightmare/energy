# frozen_string_literal: true

class MeterOverviewPresenter < SimpleDelegator
  def current_power
    daily_statistics.current_power
  end

  def daily_energy
    daily_statistics.total_energy
  end

  def latest_reading
    daily_statistics.latest_reading
  end

  private

  def daily_statistics
    @daily_statistics ||= ReadingStatistics.new(
      readings,
      from: Time.current.beginning_of_day,
      to: Time.current,
      current_duration: current_duration
    )
  end
end
