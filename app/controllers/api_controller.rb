# frozen_string_literal: true
class ApiController < ActionController::Base
  before_action :check_api_key

  private

  def check_api_key
    api_key = request.env['HTTP_X_API_KEY']

    unless api_key
      return render_error(status: 401, message: 'Api-Key missing')
    end

    return if ApiKey.valid?(api_key)
    render_error(status: 403, message: 'Bad API-Key')
  end

  def render_error(status:, message:)
    render json: { error: message }, status: status
  end
end
