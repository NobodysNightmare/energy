# frozen_string_literal: true
module ApplicationHelper
  def flash_errors(errors)
    flash[:error] = errors.full_messages.join('<br>').html_safe
  end

  def site_options(selected = nil)
    sites = Site.all
    options_for_select(
      sites.map { |s| [s.name, s.id] },
      selected
    )
  end
end
