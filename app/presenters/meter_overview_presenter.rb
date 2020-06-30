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

  def generator_fraction
    return nil unless internal?

    estimate = energy_source_estimates.order(:time).last
    return nil unless estimate

    (estimate.generated_fraction * 100).round
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
