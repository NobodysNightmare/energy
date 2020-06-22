# frozen_string_literal: true

class MetersController < ApplicationController
  def index
    meters = Meter.all
    meters = meters.where(site_id: params[:site_id]) if params[:site_id]
    meters = meters.map { |inv| MeterOverviewPresenter.new(inv) }

    @active_meters = meters.select(&:active?)
    @inactive_meters = meters.reject(&:active?)
  end

  def new
    @meter = Meter.new(site_id: params[:site_id])
    render :edit
  end

  def edit
    @meter = Meter.find(params[:id])
  end

  def create
    meter = Meter.create(meter_params)
    if meter.persisted?
      flash[:success] = I18n.t('flashs.created_model',
                               model: Meter.model_name.human)
    else
      flash_errors(meter.errors)
    end
    redirect_to action: :index
  end

  def update
    meter = Meter.find(params[:id])
    if meter.update(meter_params)
      flash[:success] = I18n.t('flashs.updated_model',
                               model: Meter.model_name.human)
    else
      flash_errors(meter.errors)
    end

    redirect_to action: :index
  end

  def destroy
    Meter.find(params[:id]).destroy
    flash[:success] = I18n.t('flashs.destroyed_model',
                             model: Meter.model_name.human)
    redirect_to action: :index
  end

  private

  def meter_params
    result = params.require(:meter).permit(:name, :serial, :site_id, :meter_type, :current_duration, :active)
    convert_duration!(result)
    result
  end

  def convert_duration!(params_hash)
    if params_hash[:current_duration]
      params_hash[:current_duration] = params_hash[:current_duration].to_i * 60
    end
  end
end
