# frozen_string_literal: true
class MetersController < ApplicationController
  def index
    @meters = Meter.all.map { |inv| MeterOverviewPresenter.new(inv) }
  end

  def new
    @meter = Meter.new
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
    params.require(:meter).permit(:name, :serial, :capacity)
  end
end
