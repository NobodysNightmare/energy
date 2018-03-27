# frozen_string_literal: true

class SitesTimelinesController < ApplicationController
  def index
    now = Time.current
    @site = Site.find(params[:id])
    @timeline = SiteTimeline.new(@site, now - 20.days, now)
  end
end
