class UsersController < ApplicationController
    # before_action :require_admin, only: %i[destroy]
    # before_action :set_user, only: [:add_favorite, :remove_favorite]
    before_action :authenticate_user!, except: [:create, :index]
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
      
        if user_params[:admin] && !current_user.admin?
          redirect_to @user, alert: 'You are not authorized to change admin status.'
        elsif @user.update(user_params)
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

    def add_favorite
        event = Event.find(params[:event_id])
        if @user.favorite_events.include?(event)
            render json: { error: 'Event already favorited' }, status: :unprocessable_entity
        else
            @user.favorite_events << event
            render json: { message: 'Event added to favorites', favorites: @user.favorite_events }, status: :ok
        end
    end
    def remove_favorite
        event = Event.find(params[:event_id])
        if @user.favorite_events.include?(event)
            @user.favorite_events.delete(event)
            render json: @user.favorite_events, status: :ok
        else
            render json: { error: 'Event not found in favorites' }, status: :unprocessable_entity
        end
      end

    private
    def user_params
      params.permit(:name, :email, :password)
    end

    def set_user
        @user = User.find(params[:id])
      end
    
    def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
    end
    
    def require_admin
        unless current_user.admin?
          redirect_to root_path, alert: 'You are not authorized to perform this action.'
        end
    end
end
