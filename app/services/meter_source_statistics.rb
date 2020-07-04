# frozen_string_literal: true

class MeterSourceStatistics
  attr_reader :from, :to

  def initialize(meter, from:, to:)
    @meter = meter
    @from = from
    @to = to
  end

  def generated
    @generated ||= if @meter.internal?
        ReadingStatistics.new(
          @meter.energy_source_estimates,
          from: @from,
          to: @to,
          energy_accessor: :generated
        )
      else
        NullStatistics.new
      end
  end

  def imported
    @imported ||= if @meter.internal?
        ReadingStatistics.new(
          @meter.energy_source_estimates,
          from: @from,
          to: @to,
          energy_accessor: :imported
        )
      else
        ReadingStatistics.new(
          @meter.readings,
          from: @from,
          to: @to
        )
      end
  end

  def total
    @total ||= CollectiveReadingStatistics.new([generated, imported])
  end
end
