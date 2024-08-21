class Event < ApplicationRecord
    validates :name, :description, presence: true
    has_many :favorites, dependent: :destroy
    has_many :favorited_by_users, through: :favorites, source: :user
end
