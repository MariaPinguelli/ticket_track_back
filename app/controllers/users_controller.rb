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
        @user = User.find(params[:id])
        if @user.update(user_params)
          render json: @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
    end

    def destroy
        @user = User.find(params[:id])
        @user.destroy
        head :no_content
    end

    private
    def user_params
      params.permit(:name, :email, :password)
    end
end
