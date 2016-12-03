# frozen_string_literal: true
class ApplicationController < ActionController::Base
  include HttpAcceptLanguage::AutoLocale

  protect_from_forgery with: :exception
  before_action :require_login

  private

  def current_user
    @current_user ||= User.find_by(user_id: session[:user_id])
  end

  def require_login
    return redirect_to no_session_path if current_user.nil?

    redirect_to no_privileges_path unless current_user.active?
  end
end
