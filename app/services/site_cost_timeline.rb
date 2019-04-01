# frozen_string_literal: true

class SiteCostTimeline < Timeline
  def initialize(site, from, to)
    statistics = SiteStatistics.new(site, from, to)
    @import_cost = RateCalculator.new(site.rates, :import_rate, statistics.imports)
    @export_gain = RateCalculator.new(site.rates, :export_rate, statistics.exports)

    self_consumption = AggregatedReadingStatistics.new(
      [statistics.generators, statistics.exports],
      ->(generated, exported) { generated - exported }
    )
    @self_consume_cost = RateCalculator.new(site.rates, :self_consume_rate, self_consumption)

    super(from, to)
  end

  private

  def columns
    {
      import_cost: @import_cost.method(:cost_between),
      export_gain: @export_gain.method(:cost_between),
      self_consume_cost: @self_consume_cost.method(:cost_between)
    }
  end
end
