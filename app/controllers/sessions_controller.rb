# frozen_string_literal: true
class SessionsController < ApplicationController
  skip_before_action :require_login
  skip_before_action :verify_authenticity_token, only: :create

  def missing
  end

  def insufficient
  end

  def new
    return redirect_to '/auth/google' if Rails.env.production?

    redirect_to '/auth/developer'
  end

  def create
    auth_hash = request.env['omniauth.auth']
    session[:user_id] = auth_hash[:uid]
    user = User.find_or_initialize_by(user_id: session[:user_id])
    user.update_attributes!(
      email: auth_hash.dig(:info, :email),
      name: auth_hash.dig(:info, :name)
    )
    redirect_to root_path
  end

  def destroy
    session.clear
    redirect_to no_session_path
  end
end
