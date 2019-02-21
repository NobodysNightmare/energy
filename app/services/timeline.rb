# frozen_string_literal: true

class Timeline
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

  attr_writer :period

  def initialize(from, to)
    @from = from.to_time
    @to = to.to_time
  end

  def period
    @period ||= default_period
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

  def columns
    raise NotImplementedError, 'Need to implement #columns as hash: key => ReadingStatistics'
  end

  def make_row(from, to)
    row = {
      from: from,
      to: to,
      formatted_period: format_period(from)
    }

    columns.each do |key, stats|
      row[key] = stats.energy_between(from, to)
    end

    row
  end

  # TODO: refine and match with period_duration
  def format_period(from)
    format = PERIOD_FORMATS[period]
    I18n.l from, format: format
  end

  def default_period
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
end
