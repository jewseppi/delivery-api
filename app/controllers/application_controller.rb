class ApplicationController < ActionController::API
  before_action :authenticate_request
  
  attr_reader :current_user
  
  protected
  
  def authenticate_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    
    begin
      @decoded = AuthService.decode(header) if header
      @current_user = User.find(@decoded[:user_id]) if @decoded
    rescue ActiveRecord::RecordNotFound
      @current_user = nil
    end
    
    render_unauthorized unless @current_user
  end
  
  def render_unauthorized(message = 'Unauthorized')
    render json: { error: message }, status: :unauthorized
  end
  
  def render_forbidden(message = 'Forbidden')
    render json: { error: message }, status: :forbidden
  end
  
  def render_not_found(message = 'Not found')
    render json: { error: message }, status: :not_found
  end
  
  def render_unprocessable_entity(errors)
    render json: { errors: errors }, status: :unprocessable_entity
  end
  
  def require_restaurant!
    render_forbidden unless current_user&.restaurant?
  end
  
  def require_driver!
    render_forbidden unless current_user&.driver?
  end
  
  def require_admin!
    render_forbidden unless current_user&.admin?
  end
end