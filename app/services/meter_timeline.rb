# frozen_string_literal: true

class MeterTimeline < Timeline
  def initialize(meter, from, to)
    @meter = meter
    super(from, to)
  end

  private

  def columns
    {
      meter: meter_statistics
    }
  end

  def meter_statistics
    @meter_statistics ||= ReadingStatistics.new(
      @meter.readings,
      from: @from,
      to: @to
    )
  end
end
