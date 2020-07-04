# frozen_string_literal: true

class MeterSourceStatistics
  attr_reader :from, :to

  def initialize(meter, from, to)
    @meter = meter
    @from = from
    @to = to
  end

  def generated
    @generated ||= ReadingStatistics.new(
      @meter.energy_source_estimates,
      from: @from,
      to: @to,
      energy_accessor: :generated
    )
  end

  def imported
    @imported ||= ReadingStatistics.new(
      @meter.energy_source_estimates,
      from: @from,
      to: @to,
      energy_accessor: :imported
    )
  end

  def total
    @total ||= CollectiveReadingStatistics.new([generated, imported])
  end
end
