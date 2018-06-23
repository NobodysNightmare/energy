# frozen_string_literal: true

module ApplicationHelper
  def site_options(selected = nil)
    sites = Site.all
    options_for_select(
      sites.map { |s| [s.name, s.id] },
      selected
    )
  end
end
