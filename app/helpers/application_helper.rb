# frozen_string_literal: true
module ApplicationHelper
  def flash_errors(errors)
    flash[:error] = errors.full_messages.join('<br>').html_safe
  end
end
