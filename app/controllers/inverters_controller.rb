# frozen_string_literal: true
class InvertersController < ApplicationController
  def index
    @inverters = Inverter.all
  end

  def new
    @inverter = Inverter.new
    render :edit
  end

  def edit
    @inverter = Inverter.find(params[:id])
  end

  def create
    inverter = Inverter.create(inverter_params)
    if inverter.persisted?
      flash[:success] = I18n.t('flashs.created_model',
                               model: Inverter.model_name.human)
    else
      flash[:error] = inverter.errors.full_messages.join('<br>').html_safe
    end
    redirect_to action: :index
  end

  def update
    inverter = Inverter.find(params[:id])
    if inverter.update(inverter_params)
      flash[:success] = I18n.t('flashs.updated_model',
                               model: Inverter.model_name.human)
    else
      flash[:error] = inverter.errors.full_messages.join('<br>').html_safe
    end
    redirect_to action: :index
  end

  def destroy
    Inverter.find(params[:id]).destroy
    flash[:success] = I18n.t('flashs.destroyed_model',
                             model: Inverter.model_name.human)
    redirect_to action: :index
  end

  private

  def inverter_params
    params.require(:inverter).permit(:name, :serial, :capacity)
  end
end
