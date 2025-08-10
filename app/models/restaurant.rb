class Restaurant < ApplicationRecord
  belongs_to :user
  has_many :payment_methods, dependent: :destroy
  has_many :delivery_requests, dependent: :destroy
  has_many :payment_batches, dependent: :destroy
  
  validates :name, :address, :city, :state, :zip_code, presence: true
  validates :latitude, :longitude, presence: true, numericality: true
  
  scope :active, -> { where(active: true) }
  
  def default_payment_method
    payment_methods.where(default: true, active: true).first
  end
end