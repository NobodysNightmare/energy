# frozen_string_literal: true

class ApiController < ActionController::Base
  before_action :check_api_key

  private

  def check_api_key
    api_key = fetch_bearer_token || request.env['HTTP_X_API_KEY']

    return render_error(status: 401, message: 'Api-Key missing') unless api_key

    return if ApiKey.valid?(api_key)
    render_error(status: 403, message: 'Bad API-Key')
  end

  def render_error(status:, message:)
    render json: { error: message }, status: status
  end

  def fetch_bearer_token
    auth = request.env['HTTP_AUTHORIZATION']
    return nil if auth.nil?
    type, token = auth.split(' ', 2)
    return nil if type != 'Bearer'
    token
  end
end
