class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @favorites = current_user.favorites.includes(:event).map(&:event)
    render json: @favorites
  end

  def create
    # Verifica se o evento existe
    event = Event.find(params[:event_id])

    # Cria uma nova instância de Favorite associada ao usuário atual e ao evento
    favorite = current_user.favorites.new(event: event)

    if favorite.save
      render json: { message: 'Event favorited successfully' }, status: :created
    else
      render json: { error: 'Unable to favorite event' }, status: :unprocessable_entity
    end
  end

  private

  # Adiciona um método de configuração do evento se necessário
  def set_event
    @event = Event.find(params[:event_id])
  end
end