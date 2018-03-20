# frozen_string_literal: true
class CollectiveReadingStatistics
  def initialize(statistics)
    @statistics = statistics
  end

  def current_power
    @statistics.map(&:current_power).sum
  end

  def total_energy
    @statistics.map(&:total_energy).sum
  end

  def latest_reading
    @statistics.map(&:latest_reading).max
  end

  private

  def latest_cycle
    @latest_cycle ||= readings.order(time: :desc)
                              .limit(2)
                              .reverse
  end
end
