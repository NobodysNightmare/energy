# frozen_string_literal: true

class ReadingsController < ApplicationController
  helper_method :meter

  def index
    @readings = meter.readings
                     .order(time: :desc)
                     .page(params[:page])
                     .per(100)
  end

  def around
    finder = NeighbourFinder.new(meter.readings.order(time: :asc))
    time = Date.iso8601(params[:time]).beginning_of_day
    before, after = finder.readings_around(time)
    render json: {
      before: { time: I18n.l(before.time, format: :short), value: helpers.format_watt_hours(before.value) },
      after: { time: I18n.l(after.time, format: :short), value: helpers.format_watt_hours(after.value) }
    }
  end

  def new
    @reading = Reading.new(meter_id: params[:meter_id], time: Time.current)
  end

  def create
    reading = Reading.create(reading_params)
    if reading.persisted?
      ReadingUpdateAnnouncer.announce(reading)
      flash[:success] = I18n.t('flashs.created_model',
                               model: Reading.model_name.human)
    else
      flash_errors(reading.errors)
    end
    redirect_to action: :index
  end

  def update
    reading = Reading.find(params[:id])
    if reading.update(reading_params)
      ReadingUpdateAnnouncer.announce(reading)
      flash[:success] = I18n.t('flashs.updated_model',
                               model: Reading.model_name.human)
    else
      flash_errors(reading.errors)
    end

    redirect_to action: :edit
  end

  def destroy
    Reading.find(params[:id]).destroy
    flash[:success] = I18n.t('flashs.destroyed_model',
                             model: Reading.model_name.human)
    redirect_to action: :index
  end

  private

  def meter
    @meter ||= Meter.find(params[:meter_id])
  end

  def reading_params
    params.require(:reading).permit(:meter_id, :time, :value)
  end
end
