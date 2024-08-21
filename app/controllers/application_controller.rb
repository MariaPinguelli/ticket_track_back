class ApplicationController < ActionController::API
    def authenticate_user!
        token = request.headers['Authorization']
        if token.present?
        decoded_token = decode_token(token)
        @current_user = User.find_by(id: decoded_token[:user_id]) if decoded_token
        end
    
        render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
    end
      
    private
    
    def decode_token(token)
        secret = Rails.application.secrets.secret_key_base
        begin
        JWT.decode(token, secret, true, algorithm: 'HS256')[0].symbolize_keys
        rescue
        nil
        end
    end
    end
