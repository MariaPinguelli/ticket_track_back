class EventsController < ApplicationController
    def index
        @event = Event.all
        render json: @event
    end

    def show
        @event = Event.find(params[:id])
        render json: @event
    end

    def create
        @event = Event.new(event_params)
        if @event.save
            render json: @event, status: :created
        else
            render json: @event.errors, status: :unprocessable_entity
        end
    end

    def update
        @event = Event.find(params[:id])
        if @event.update(event_params)
          render json: @event
        else
          render json: @event.errors, status: :unprocessable_entity
        end
    end

    def destroy
        @event = Event.find(params[:id])
        @event.destroy
        head :no_content
    end

    private
    def event_params
      params.permit(:name, :date, :description)
    end
end
