# frozen_string_literal: true

module Api
  class MetersController < ApiController
    TYPES_SUPPORTING_COSTS = %i[grid_import internal]

    def usage
      render json: usage_result
    end

    private

    def usage_result
      result = { energy: meter_statistics.total.total_energy.to_i, cost: nil }

      if TYPES_SUPPORTING_COSTS.include?(meter.meter_type.to_sym)
        result[:cost] = calculate_cost.round(2).to_f
      end

      result
    end

    def meter
      @meter ||= Meter.includes(site: :rates).find_by!(serial: params.fetch(:serial))
    end

    def meter_statistics
      @meter_statistics ||= MeterSourceStatistics.new(
        meter,
        from: from,
        to: to
      )
    end

    def import_rate_calculator
      @import_rate_calculator ||= RateCalculator.new(meter.site.rates, :import_rate, meter_statistics.imported)
    end

    def generator_rate_calculator
      @generator_rate_calculator ||= RateCalculator.new(
        meter.site.rates,
        ->(r) { r.export_rate + r.self_consume_rate },
        meter_statistics.generated
      )
    end

    def calculate_cost
      import_rate_calculator.cost_between(from, to) +
        generator_rate_calculator.cost_between(from, to)
    end

    def from
      Time.iso8601(params[:from])
    rescue ArgumentError => e
      raise ClientError, e.message
    end

    def to
      Time.iso8601(params[:to])
    rescue ArgumentError => e
      raise ClientError, e.message
    end
  end
end
