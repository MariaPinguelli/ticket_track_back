class User < ApplicationRecord
    has_secure_password
    validates :email, presence: true, uniqueness: true
    # validates :name, presence: true
    # validates :password, presence: true 
    has_many :favorites, dependent: :destroy
    has_many :favorite_events, through: :favorites, source: :event
end
