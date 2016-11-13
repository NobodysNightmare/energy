# frozen_string_literal: true
class InverterReadingsController < ApplicationController
  helper_method :inverter

  def index
    @readings = inverter.inverter_readings.order(:time)
  end

  private

  def inverter
    @inverter ||= Inverter.find(params[:inverter_id])
  end
end
