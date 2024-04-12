class UsersController < ApplicationController
    def index
        @users = User.all
    end

    def show
        @users = User.find(params[:id])
    end

    def create
        @users = User.new(user_params)
        @users.save
    end

    def update
        @users = User.find(params[:id])
    end

    def destroy
        @users = User.find(params[:id])
    end

    private
    def user_params
      params.require(:user).permit(:name, :email)
    end
end
