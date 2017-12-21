# frozen_string_literal: true
class ReadingsController < ApplicationController
  helper_method :meter

  def index
    @readings = meter.readings
                     .order(time: :desc)
                     .page(params[:page])
                     .per(100)
  end

  private

  def meter
    @meter ||= Meter.find(params[:meter_id])
  end
end
