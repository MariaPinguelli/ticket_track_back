class ApplicationController < ActionController::API
    before_action :authenticate_user 
    include ActionController::Cookies 
  
    private 
  
    def  current_user 
        user = User.find_by(id: session[:user_id])
        Rails.logger.info "Current User ID: #{session[:user_id]}" # Adiciona uma linha de log
        @current_user ||= user

    end
  
   private 
  
    def  authenticate_user
       render json: { error:  'Não autorizado' }, status:  :unauthorized  unless current_user 
    end 
end
