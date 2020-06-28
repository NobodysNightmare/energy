# frozen_string_literal: true

class SiteStatistics
  attr_reader :from, :to

  def initialize(site, from, to)
    @site = site
    @from = from
    @to = to
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
