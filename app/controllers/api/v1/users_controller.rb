class Api::V1::UsersController < ApplicationController
	# Module which contains encode and decoding logic
   include AuthToken

  skip_before_action :authenticate_request, only: [:login, :sign_up]


  swagger_controller :users, "User Sessions Management"

  swagger_api :login do
    summary 'Session login'
    notes 'For creating a session for api'
    param :form, :email, :string, :required, "Email"
    param :form, :password, :password, :required, "Password"
    response :ok
    response :not_found
    response :not_acceptable
    response :bad_request
  end
  def login
    user = User.find_by_email(params[:email])
    if user && user.valid_password?(params[:password])
      # @token = AuthToken.encode(user_id: user.id, client_ip: request.env['REMOTE_ADDR'], client: request.env['HTTP_USER_AGENT'])
      @current_apikey = AuthToken.encode(user_id: user.id, time: Time.now)
      $redis.hset(@current_apikey, 'user_id', user.id)
      $redis.expire(@current_apikey, 20.minutes.to_i)
      render json: { api_key: @current_apikey, expires_in: '20 minutes' }
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  swagger_api :logout do
    summary 'Destroys api-key thereby destroying user session'
    notes 'Destroy Session'
    response :ok
    response :not_found
    response :not_acceptable
    response :bad_request
  end
  def logout
    $redis.del(current_apikey)
    head :ok
  end

  swagger_api :sign_up do
    summary 'Allows user to sign_up for polling'
    notes 'Email, password and username are required'
    param :form, :'user[email]', :string, :required, 'Email'
    param :form, :'user[password]', :password, :required, 'Password'
    param :form, :'user[username]', :string, :required, 'Username'
  end
  def sign_up
    p 'param'
    p params
    @user = User.create(user_params)
    if @user
      render json: @user
    else
      render @user.errors
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :username)
  end
end
