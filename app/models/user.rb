class User < ApplicationRecord
  has_secure_password
  
  enum :role, { restaurant: 0, driver: 1, admin: 2 }
  
  has_one :restaurant, dependent: :destroy
  has_one :driver, dependent: :destroy
  
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true, uniqueness: true
  validates :first_name, :last_name, presence: true
  validates :role, presence: true
  
  before_validation :normalize_phone
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  private
  
  def normalize_phone
    # Simple phone normalization - you can enhance this
    self.phone = phone.gsub(/\D/, '') if phone.present?
  end
end