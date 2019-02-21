# frozen_string_literal: true

class SiteTimeline < Timeline
  def initialize(site, from, to)
    @site = site
    super(from, to)
  end

  private

  def columns
    {
      generated: generators,
      exported: exports,
      imported: imports
    }
  end

  def generators
    @generators ||= CollectiveReadingStatistics.new(
      @site.meters.generator.map do |meter|
        ReadingStatistics.new(
          meter.readings,
          from: @from,
          to: @to
        )
      end
    )
  end

  def exports
    @exports ||= CollectiveReadingStatistics.new(
      @site.meters.grid_export.map do |meter|
        ReadingStatistics.new(
          meter.readings,
          from: @from,
          to: @to
        )
      end
    )
  end

  def imports
    @imports ||= CollectiveReadingStatistics.new(
      @site.meters.grid_import.map do |meter|
        ReadingStatistics.new(
          meter.readings,
          from: @from,
          to: @to
        )
      end
    )
  end
end
