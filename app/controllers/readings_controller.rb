# frozen_string_literal: true
class ReadingsController < ApplicationController
  helper_method :meter

  def index
    @readings = meter.readings
                     .order(time: :desc)
                     .page(params[:page])
                     .per(100)
  end

  def new
    @reading = Reading.new(meter_id: params[:meter_id], time: Time.current)
  end

  def create
    reading = Reading.create(reading_params)
    if reading.persisted?
      flash[:success] = I18n.t('flashs.created_model',
                               model: Reading.model_name.human)
    else
      flash_errors(reading.errors)
    end
    redirect_to meters_path
  end

  def update
    reading = Reading.find(params[:id])
    if reading.update(reading_params)
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
    redirect_to '/'
  end

  private

  def meter
    @meter ||= Meter.find(params[:meter_id])
  end

  def reading_params
    params.require(:reading).permit(:meter_id, :time, :value)
  end
end
