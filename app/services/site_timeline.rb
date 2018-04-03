# frozen_string_literal: true

class SiteTimeline
  PERIOD_FORMATS = {
    day: :date,
    week: :week,
    month: :month,
    year: :year
  }.freeze

  PERIOD_DURATIONS = {
    day: 1.day,
    week: 1.week,
    month: 1.month,
    year: 1.year
  }.freeze

  def initialize(site, from, to)
    @site = site
    @from = from.to_time
    @to = to.to_time
  end

  def period
    duration = @to - @from
    if duration <= 31.days
      :day
    elsif duration <= 30.weeks
      :week
    elsif duration <= 36.months
      :month
    else
      :year
    end
  end

  def rows
    @rows ||= periods.map { |from, to| make_row(from, to) }
  end

  private

  def periods
    result = []
    from = @from.public_send("beginning_of_#{period}")
    while from < @to
      to = [from + period_duration, @to].min
      result << [from, to]
      from += period_duration
    end
    result
  end

  def period_duration
    PERIOD_DURATIONS[period]
  end

  def make_row(from, to)
    {
      from: from,
      to: to,
      formatted_period: format_period(from),
      generated: generators.energy_between(from, to),
      exported: exports.energy_between(from, to),
      imported: imports.energy_between(from, to)
    }
  end

  # TODO: refine and match with period_duration
  def format_period(from)
    format = PERIOD_FORMATS[period]
    I18n.l from, format: format
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
