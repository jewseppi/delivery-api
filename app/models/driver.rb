class Driver < ApplicationRecord
  belongs_to :user
  has_many :delivery_requests, dependent: :nullify
  has_many :driver_applications, dependent: :destroy
  has_many :driver_locations, dependent: :destroy
  
  enum :status, { offline: 0, available: 1, busy: 2 }
  
  validates :license_number, presence: true, uniqueness: true
  validates :status, presence: true
  validates :rating, presence: true, numericality: { in: 0.0..5.0 }
  
  scope :active, -> { where(active: true) }
  scope :available_for_delivery, -> { active.available }
  
  def current_location
    driver_locations.order(recorded_at: :desc).first
  end
  
  def update_location!(latitude, longitude, accuracy = nil)
    driver_locations.create!(
      latitude: latitude,
      longitude: longitude,
      accuracy_meters: accuracy,
      recorded_at: Time.current
    )
    
    update!(
      current_latitude: latitude,
      current_longitude: longitude
    )
  end
end