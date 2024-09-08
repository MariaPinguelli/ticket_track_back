class Event < ApplicationRecord
    validates :name, :description, presence: true
    has_many :favorites
end
