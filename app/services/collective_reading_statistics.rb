# frozen_string_literal: true

class CollectiveReadingStatistics
  def initialize(statistics)
    @statistics = AggregatedReadingStatistics.new(statistics, ->(*s) { s.sum })
  end

  def current_power
    @statistics.current_power
  end

  def total_energy
    @statistics.total_energy
  end

  def energy_between(from, to)
    @statistics.energy_between(from, to)
  end

  def latest_reading
    @statistics.latest_reading
  end
end
