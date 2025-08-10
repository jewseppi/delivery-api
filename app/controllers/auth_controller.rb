class AuthController < ApplicationController
  skip_before_action :authenticate_request, only: [:login, :register, :refresh]
  
  # POST /auth/login
  def login
    user = User.find_by(email: params[:email])
    
    if user && user.authenticate(params[:password])
      if user.active?
        token = AuthService.encode(user_id: user.id, role: user.role)
        render json: {
          token: token,
          user: user_data(user),
          expires_at: 24.hours.from_now
        }
      else
        render json: { error: 'Account is deactivated' }, status: :unauthorized
      end
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end
  
  # POST /auth/register
  def register
    user = User.new(user_params)
    
    if user.save
      token = AuthService.encode(user_id: user.id, role: user.role)
      render json: {
        token: token,
        user: user_data(user),
        expires_at: 24.hours.from_now
      }, status: :created
    else
      render_unprocessable_entity(user.errors.full_messages)
    end
  end
  
  # POST /auth/refresh
  def refresh
    if current_user
      token = AuthService.encode(user_id: current_user.id, role: current_user.role)
      render json: {
        token: token,
        user: user_data(current_user),
        expires_at: 24.hours.from_now
      }
    else
      render_unauthorized('Token expired or invalid')
    end
  end
  
  # POST /auth/logout
  def logout
    render json: { message: 'Logged out successfully' }
  end
  
  private
  
  def user_params
    params.permit(:email, :password, :password_confirmation, :first_name, :last_name, :phone, :role)
  end
  
  def user_data(user)
    {
      id: user.id,
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name,
      full_name: user.full_name,
      phone: user.phone,
      role: user.role,
      active: user.active,
      created_at: user.created_at
    }
  end
end