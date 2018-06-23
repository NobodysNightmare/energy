# frozen_string_literal: true

module Api
  class PrometheusController < ApiController
    def index
      readings = Reading.includes(meter: :site).order(time: :desc).limit(limit)
      render plain: PrometheusFormatter.format(readings)
    end

    private

    def limit
      return Integer(params[:limit]) if params[:limit]
      1000
    end
  end
end
