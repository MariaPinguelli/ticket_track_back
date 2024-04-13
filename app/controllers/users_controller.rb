class UsersController < ApplicationController
    def index
        @users = User.all
        render json: @users
    end

    def show
        @users = User.find(params[:id])
        render json: @users
    end

    def create
        @users = User.new(user_params)
        if @users.save
            render json: @users, status: :created
        else
            render json: @users.errors, status: :unprocessable_entity
        end
    end

    def update
        @users = User.find(params[:id])
    end

    def destroy
        @users = User.find(params[:id])
    end

    private
    def user_params
      params.permit(:name, :email, :password)
    end
end
