# frozen_string_literal: true
class SitesController < ApplicationController
  def index
    @sites = Site.all
  end

  def new
    @site = Site.new
    render :edit
  end

  def edit
    @site = Site.find(params[:id])
  end

  def create
    site = Site.create(site_params)
    if site.persisted?
      flash[:success] = I18n.t('flashs.created_model',
                               model: Site.model_name.human)
    else
      flash_errors(site.errors)
    end
    redirect_to action: :index
  end

  def update
    site = Site.find(params[:id])
    if site.update(site_params)
      flash[:success] = I18n.t('flashs.updated_model',
                               model: Site.model_name.human)
    else
      flash_errors(site.errors)
    end

    redirect_to action: :index
  end

  def destroy
    Site.find(params[:id]).destroy
    flash[:success] = I18n.t('flashs.destroyed_model',
                             model: Site.model_name.human)
    redirect_to action: :index
  end

  private

  def site_params
    params.require(:site).permit(:name)
  end
end
