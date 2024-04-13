class User < ApplicationRecord
    has_secure_password

    attr_accessor :email, :name
end
