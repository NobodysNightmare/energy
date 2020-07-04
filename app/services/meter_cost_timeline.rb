# frozen_string_literal: true

class MeterCostTimeline < Timeline
  def initialize(meter, from, to)
    @statistics = MeterSourceStatistics.new(meter, from, to)

    @import_cost = RateCalculator.new(meter.site.rates, :import_rate, @statistics.imported)
    @generator_cost = RateCalculator.new(meter.site.rates, ->(r) { r.export_rate + r.self_consume_rate }, @statistics.generated)

    super(from, to)
  end

  private

  def columns
    {
      import_amount: @statistics.imported.method(:energy_between),
      import_cost: @import_cost.method(:cost_between),
      generator_amount: @statistics.generated.method(:energy_between),
      generator_cost: @generator_cost.method(:cost_between)
    }
  end
end
