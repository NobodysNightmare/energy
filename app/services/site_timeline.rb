# frozen_string_literal: true

class SiteTimeline < Timeline
  def initialize(site, from, to)
    @statistics = SiteStatistics.new(site, from, to)
    super(from, to)
  end

  private

  def columns
    {
      generated: @statistics.generators.method(:energy_between),
      exported: @statistics.exports.method(:energy_between),
      imported: @statistics.imports.method(:energy_between)
    }
  end
end
