# frozen_string_literal: true

class AggregatedReadingStatistics
  def initialize(statistics, aggregator)
    @statistics = statistics
    @aggregator = aggregator
  end

  def current_power
    powers = @statistics.map(&:current_power)
    @aggregator.call(*powers)
  end

  def total_energy
    energies = @statistics.map(&:total_energy)
    @aggregator.call(*energies)
  end

  def energy_between(from, to)
    energies = @statistics.map { |s| s.energy_between(from, to) }
    @aggregator.call(*energies)
  end

  def latest_reading
    @statistics.map(&:latest_reading).compact.max_by(&:time)
  end
end
