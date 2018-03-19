# frozen_string_literal: true
class SiteOverviewPresenter < SimpleDelegator
  def current_power
    daily_statistics.map(&:current_power).sum
  end

  def daily_energy
    # TODO: generalize all statistics to consider
    # different meter types
    daily_statistics.map(&:total_energy).sum
  end

  def latest_reading
    daily_statistics.map(&:latest_reading).max
  end

  private

  def daily_statistics
    @daily_statistics ||= meters.map do |meter|
      ReadingStatistics.new(
        meter.readings,
        from: Time.current.beginning_of_day,
        to: Time.current.end_of_day
      )
    end
  end
end
