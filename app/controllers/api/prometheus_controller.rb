# frozen_string_literal: true

module Api
  class PrometheusController < ApiController
    def index
      meters = Meter.includes(:site).all
      readings = meters.map { |m| m.readings.order(:time).last }
      render plain: PrometheusFormatter.format(readings)
    end
  end
end
