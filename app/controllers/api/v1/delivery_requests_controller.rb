class Api::V1::DeliveryRequestsController < ApplicationController
  before_action :set_delivery_request, only: [:show, :assign_driver, :pickup, :deliver, :cancel]
  
  # GET /api/v1/delivery_requests
  def index
    case current_user.role
    when 'restaurant'
      @delivery_requests = current_user.restaurant.delivery_requests if current_user.restaurant
    when 'driver'
      @delivery_requests = current_user.driver.delivery_requests if current_user.driver
    when 'admin'
      @delivery_requests = DeliveryRequest.all
    end
    
    @delivery_requests ||= DeliveryRequest.none
    @delivery_requests = @delivery_requests.includes(:restaurant, :driver).order(created_at: :desc)
    
    render json: @delivery_requests.map { |delivery| delivery_data(delivery) }
  end
  
  # GET /api/v1/delivery_requests/available (for drivers)
  def available
    require_driver!
    
    @requests = DeliveryRequest.available_for_drivers
                              .includes(:restaurant)
                              .order(created_at: :desc)
    
    render json: @requests.map { |delivery| delivery_data(delivery) }
  end
  
  # POST /api/v1/delivery_requests
  def create
    require_restaurant!
    
    @delivery_request = current_user.restaurant.delivery_requests.build(delivery_request_params)
    
    if @delivery_request.save
      render json: delivery_data(@delivery_request), status: :created
    else
      render_unprocessable_entity(@delivery_request.errors.full_messages)
    end
  end
  
  # GET /api/v1/delivery_requests/:id
  def show
    render json: delivery_data(@delivery_request)
  end
  
  # POST /api/v1/delivery_requests/:id/assign_driver
  def assign_driver
    require_restaurant!
    driver = Driver.find(params[:driver_id])
    
    @delivery_request.assign_to_driver!(driver)
    render json: delivery_data(@delivery_request)
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
  
  # POST /api/v1/delivery_requests/:id/pickup
  def pickup
    require_driver!
    
    if @delivery_request.driver == current_user.driver && @delivery_request.assigned?
      @delivery_request.mark_picked_up!
      render json: delivery_data(@delivery_request)
    else
      render_forbidden('Not authorized to pick up this order')
    end
  end
  
  # POST /api/v1/delivery_requests/:id/deliver
  def deliver
    require_driver!
    
    if @delivery_request.driver == current_user.driver && @delivery_request.picked_up?
      @delivery_request.mark_delivered!
      render json: delivery_data(@delivery_request)
    else
      render_forbidden('Not authorized to deliver this order')
    end
  end
  
  # POST /api/v1/delivery_requests/:id/cancel
  def cancel
    if can_cancel_request?
      @delivery_request.update!(status: :cancelled, cancelled_at: Time.current)
      render json: delivery_data(@delivery_request)
    else
      render_forbidden('Not authorized to cancel this request')
    end
  end
  
  private
  
  def set_delivery_request
    @delivery_request = DeliveryRequest.find(params[:id])
  end
  
  def delivery_request_params
    params.require(:delivery_request).permit(
      :order_number, :order_notes, :order_total,
      :pickup_address, :pickup_latitude, :pickup_longitude, :pickup_notes,
      :delivery_address, :delivery_latitude, :delivery_longitude,
      :customer_name, :customer_phone, :delivery_notes
    )
  end
  
  def can_cancel_request?
    case current_user.role
    when 'restaurant'
      @delivery_request.restaurant == current_user.restaurant
    when 'admin'
      true
    else
      false
    end
  end
  
  def delivery_data(delivery)
    {
      id: delivery.id,
      order_number: delivery.order_number,
      status: delivery.status,
      customer_name: delivery.customer_name,
      customer_phone: delivery.customer_phone,
      pickup_address: delivery.pickup_address,
      delivery_address: delivery.delivery_address,
      delivery_fee: delivery.delivery_fee,
      platform_fee: delivery.platform_fee,
      driver_payout: delivery.driver_payout,
      restaurant_name: delivery.restaurant.name,
      driver_name: delivery.driver&.user&.full_name,
      requested_at: delivery.requested_at,
      assigned_at: delivery.assigned_at,
      picked_up_at: delivery.picked_up_at,
      delivered_at: delivery.delivered_at,
      created_at: delivery.created_at
    }
  end
end