class DeliveryRequest < ApplicationRecord
  belongs_to :restaurant
  belongs_to :driver, optional: true
  has_many :driver_applications, dependent: :destroy
  has_many :applied_drivers, through: :driver_applications, source: :driver
  has_many :driver_locations
  has_one :batch_delivery, dependent: :destroy
  has_one :payment_batch, through: :batch_delivery
  
  enum :status, { 
    pending: 0, 
    assigned: 1, 
    picked_up: 2, 
    delivered: 3, 
    cancelled: 4 
  }
  
  validates :order_number, presence: true, uniqueness: true
  validates :pickup_address, :delivery_address, presence: true
  validates :customer_name, :customer_phone, presence: true
  validates :delivery_fee, :platform_fee, :driver_payout, presence: true, numericality: { greater_than: 0 }
  validates :pickup_latitude, :pickup_longitude, presence: true, numericality: true
  validates :delivery_latitude, :delivery_longitude, presence: true, numericality: true
  validates :requested_at, presence: true
  
  scope :active, -> { where.not(status: :cancelled) }
  scope :available_for_drivers, -> { where(status: :pending) }
  scope :in_progress, -> { where(status: [:assigned, :picked_up]) }
  scope :completed, -> { where(status: :delivered) }
  
  before_validation :set_requested_at, on: :create
  before_validation :calculate_fees, on: :create
  
  def assign_to_driver!(driver)
    transaction do
      update!(
        driver: driver,
        status: :assigned,
        assigned_at: Time.current
      )
      
      driver.update!(status: :busy)
    end
  end
  
  def mark_picked_up!
    update!(
      status: :picked_up,
      picked_up_at: Time.current
    )
  end
  
  def mark_delivered!
    transaction do
      update!(
        status: :delivered,
        delivered_at: Time.current
      )
      
      driver.update!(status: :available) if driver
    end
  end
  
  private
  
  def set_requested_at
    self.requested_at ||= Time.current
  end
  
  def calculate_fees
    # Basic fee calculation
    self.delivery_fee ||= 8.50
    self.platform_fee ||= 1.70
    self.driver_payout ||= 6.80
  end
end