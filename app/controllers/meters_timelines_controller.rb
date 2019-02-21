# frozen_string_literal: true

class MetersTimelinesController < ApplicationController
  helper_method :start_date, :end_date, :period

  def index
    @meter = Meter.find(params[:id])
    @timeline = MeterTimeline.new(@meter, start_date, end_date.tomorrow)
    @timeline.period = period if period.present?
  end

  private

  def start_date
    if params[:start].present?
      Date.iso8601(params[:start])
    else
      Date.current - 7.days
    end
  end

  def end_date
    if params[:end].present?
      Date.iso8601(params[:end])
    else
      Date.current
    end
  end

  def period
    params[:period].presence&.to_sym
  end
end
