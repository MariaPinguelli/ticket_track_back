class User < ApplicationRecord
    has_secure_password
    validates :email, presence: true
    validates :name, presence: true

    def generate_token
        payload = { user_id: self.id }
        secret = Rails.application.secrets.secret_key_base
        token = JWT.encode(payload, secret)
        token
      end

end
