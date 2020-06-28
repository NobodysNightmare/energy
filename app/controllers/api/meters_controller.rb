# frozen_string_literal: true

module Api
  class MetersController < ApiController
    TYPES_SUPPORTING_COSTS = %i[grid_import internal]

    def usage
      render json: usage_result
    end

    private

    def usage_result
      result = { energy: meter_statistics.total_energy.to_i, cost: nil }

      if TYPES_SUPPORTING_COSTS.include?(meter.meter_type.to_sym)
        result[:cost] = rate_calculator.cost_between(from, to).round(2).to_f
      end

      result
    end

    def meter
      @meter ||= Meter.find_by!(serial: params.fetch(:serial))
    end

    def meter_statistics
      @meter_statistics ||= ReadingStatistics.new(
        meter.readings,
        from: from,
        to: to
      )
    end

    # To calculate cost generated by a meter we assume grid import cost.
    # Optimistically speaking this is a simplification. But essentially it
    # completely ignores whether energy was used, while lots of it was generated
    # locally or whether it was all taken from the grid.
    # This is an acceptable worst-case estimate, though we should have the data
    # to provide something better.
    def rate_calculator
      @rate_calculator ||= RateCalculator.new(meter.site.rates, :import_rate, meter_statistics)
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