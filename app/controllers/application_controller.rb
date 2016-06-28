class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Authenticates every request
  before_action :authenticate_request
  around_action :set_time_zone, if: :current_user

  # Not disabling CORS, instead ignoring for json requests
  skip_before_action :verify_authenticity_token, if: :json_request?

  # Exception class
  require 'exception'

  # Exception Handlers
  rescue_from Poll::Exception::AuthenticationTimeoutError, with: :authentication_timeout
  rescue_from Poll::Exception::NotAuthenticatedError, with: :not_authenticated
  rescue_from CanCan::AccessDenied, with: :forbidden

  # For Pagination helper in rabl views
  helper :api

  protected

  def json_request?
    request.format.json?
  end

  def current_apikey
    @current_apikey ||= nil
  end

  def current_user
    @current_user ||= User.find_by_id($redis.hget(@current_apikey, 'user_id')) if current_apikey
  end

  def authenticate_request
    @current_apikey = nil
    api_key = request.env['HTTP_X_API_KEY']
    raise Poll::Exception::NotAuthenticatedError unless api_key.present?
    if api_key && AuthToken.decode(api_key) && $redis.ttl(api_key) > 0
      @current_apikey = api_key
      $redis.expire(@current_apikey, 20.minutes.to_i) # set TTL as constant
    else
      raise Poll::Exception::NotAuthenticatedError
    end
  rescue JWT::ExpiredSignature
    raise Poll::Exception::AuthenticationTimeoutError
  rescue JWT::VerificationError, JWT::DecodeError
    raise Poll::Exception::NotAuthenticatedError
  end

  def authentication_timeout
    render json: { errors: 'Authentication Timeout' }, status: 419
  end

  def not_authenticated
    render json: { errors: 'Not Authenticated. Invalid Token' }, status: :unauthorized
  end

  def forbidden
    render json: {errors: 'Forbidden'}, status: :forbidden
  end

  def set_time_zone(&block)
    time_zone = current_user.try(:time_zone) || 'UTC'
    Time.use_zone(time_zone, &block)
  end
end
