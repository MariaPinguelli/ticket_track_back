class User < ApplicationRecord
    has_secure_password
    validates :email, presence: true
    validates :name, presence: true
    has_many :favorites
    has_many :favorited_events, through: :favorites, source: :event


    def generate_token
        payload = { user_id: user.id }
        secret = Rails.application.secrets.secret_key_base
        token = JWT.encode(payload, secret)
        token
      end

end
