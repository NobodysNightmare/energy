# frozen_string_literal: true

class RatesController < ApplicationController
  def index
    @site = Site.find(params[:site_id])
    @rates = @site.rates.order(:valid_from)
  end

  def new
    @rate = Rate.new(site_id: params[:site_id], valid_from: Date.today)
    render :edit
  end

  def edit
    @rate = Rate.find(params[:id])
  end

  def create
    rate = Rate.create(rate_params)
    if rate.persisted?
      flash[:success] = I18n.t('flashs.created_model',
                               model: Rate.model_name.human)
    else
      flash_errors(rate.errors)
    end
    redirect_to action: :index, site_id: rate.site_id
  end

  def update
    rate = Rate.find(params[:id])
    if rate.update(rate_params)
      flash[:success] = I18n.t('flashs.updated_model',
                               model: Rate.model_name.human)
    else
      flash_errors(rate.errors)
    end

    redirect_to action: :index, site_id: rate.site_id
  end

  def destroy
    Rate.find(params[:id]).destroy
    flash[:success] = I18n.t('flashs.destroyed_model',
                             model: Rate.model_name.human)

    redirect_to action: :index, site_id: rate.site_id
  end

  private

  def rate_params
    params.require(:rate)
          .permit(:valid_from, :site_id, :export_rate, :import_rate, :self_consume_rate)
  end
end
