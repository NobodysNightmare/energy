# frozen_string_literal: true

class SiteTimeline < Timeline
  def initialize(site, from, to)
    @statistics = SiteStatistics.new(site, from, to)
    super(from, to)
  end

  private

  def columns
    {
      generated: @statistics.generators,
      exported: @statistics.exports,
      imported: @statistics.imports
    }
  end
end
