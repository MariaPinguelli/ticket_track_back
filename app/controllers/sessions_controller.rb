class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]
  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      token= generate_token(user_id: user.id)
      session[:user_id] = user.id
      render json: {
        message: 'Login successful',
        user: {
          id: user.id,
          name: user.name,
          email: user.email,
          token: token
        }
      }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end
  
  def decode_token(token)
    JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: 'HS256')[0]
  rescue JWT::DecodeError
    nil
  end

  def destroy
    session[:user_id] = nil
    render json: { message: 'Logged out' }, status: :ok
  end
  def generate_token(payload)
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end
end
