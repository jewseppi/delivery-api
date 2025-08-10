class AuthService
  SECRET_KEY = Rails.application.secret_key_base || 'your-secret-key'
  
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end
  
  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError => e
    nil
  end
  
  def self.current_user(token)
    decoded_token = decode(token)
    return nil unless decoded_token
    
    User.find_by(id: decoded_token[:user_id])
  rescue ActiveRecord::RecordNotFound
    nil
  end
end