# db/migrate/20250808183739_create_core_schema.rb
class CreateCoreSchema < ActiveRecord::Migration[8.0]
  def change
    # Enable UUID extension
    enable_extension 'pgcrypto'
    
    # Users table (restaurants, drivers, admins)
    create_table :users, id: :uuid do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :phone, null: false
      t.integer :role, default: 0 # enum: restaurant, driver, admin
      t.boolean :active, default: true
      t.json :metadata, default: {}
      
      t.timestamps
    end
    
    add_index :users, :email, unique: true
    add_index :users, :phone, unique: true
    add_index :users, :role
    
    # Restaurants table
    create_table :restaurants, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :name, null: false
      t.string :business_license
      t.text :address, null: false
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip_code, null: false
      t.string :stripe_customer_id
      t.boolean :active, default: true
      t.json :business_hours, default: {}
      
      t.timestamps
    end
    
    add_index :restaurants, :active
    add_index :restaurants, [:latitude, :longitude]
    
    # Payment methods for restaurants
    create_table :payment_methods, id: :uuid do |t|
      t.references :restaurant, null: false, foreign_key: true, type: :uuid
      t.string :stripe_payment_method_id, null: false
      t.string :card_last_four, null: false
      t.string :card_brand, null: false
      t.integer :exp_month, null: false
      t.integer :exp_year, null: false
      t.boolean :default, default: false
      t.boolean :active, default: true
      
      t.timestamps
    end
    
    add_index :payment_methods, :default
    
    # Drivers table
    create_table :drivers, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :license_number, null: false
      t.string :vehicle_make
      t.string :vehicle_model
      t.string :vehicle_year
      t.string :vehicle_plate
      t.decimal :current_latitude, precision: 10, scale: 6
      t.decimal :current_longitude, precision: 10, scale: 6
      t.integer :status, default: 0 # enum: offline, available, busy
      t.boolean :active, default: true
      t.decimal :rating, precision: 3, scale: 2, default: 5.0
      t.integer :completed_deliveries, default: 0
      
      t.timestamps
    end
    
    add_index :drivers, :license_number, unique: true
    add_index :drivers, :status
    add_index :drivers, [:current_latitude, :current_longitude]
    add_index :drivers, :rating
    
    # Delivery requests/orders
    create_table :delivery_requests, id: :uuid do |t|
      t.references :restaurant, null: false, foreign_key: true, type: :uuid
      t.references :driver, null: true, foreign_key: true, type: :uuid
      
      # Order information
      t.string :order_number, null: false
      t.text :order_notes
      t.decimal :order_total, precision: 8, scale: 2
      
      # Pickup information
      t.text :pickup_address, null: false
      t.decimal :pickup_latitude, precision: 10, scale: 6
      t.decimal :pickup_longitude, precision: 10, scale: 6
      t.text :pickup_notes
      
      # Delivery information
      t.text :delivery_address, null: false
      t.decimal :delivery_latitude, precision: 10, scale: 6
      t.decimal :delivery_longitude, precision: 10, scale: 6
      t.string :customer_name, null: false
      t.string :customer_phone, null: false
      t.text :delivery_notes
      
      # Pricing
      t.decimal :delivery_fee, precision: 6, scale: 2, null: false
      t.decimal :platform_fee, precision: 6, scale: 2, null: false
      t.decimal :driver_payout, precision: 6, scale: 2, null: false
      
      # Status and timing
      t.integer :status, default: 0 # enum: pending, assigned, picked_up, delivered, cancelled
      t.datetime :requested_at, null: false
      t.datetime :assigned_at
      t.datetime :picked_up_at
      t.datetime :delivered_at
      t.datetime :cancelled_at
      
      # Distance and duration estimates
      t.decimal :estimated_distance_km, precision: 6, scale: 2
      t.integer :estimated_duration_minutes
      
      t.timestamps
    end
    
    add_index :delivery_requests, :order_number, unique: true
    add_index :delivery_requests, :status
    add_index :delivery_requests, :requested_at
    
    # Driver applications for delivery requests
    create_table :driver_applications, id: :uuid do |t|
      t.references :delivery_request, null: false, foreign_key: true, type: :uuid
      t.references :driver, null: false, foreign_key: true, type: :uuid
      t.integer :status, default: 0 # enum: pending, accepted, rejected
      t.text :message
      t.datetime :applied_at, null: false
      
      t.timestamps
    end
    
    add_index :driver_applications, [:delivery_request_id, :driver_id], unique: true, name: 'idx_driver_applications_unique'
    add_index :driver_applications, :status
    
    # Payment batches for processing driver payouts
    create_table :payment_batches, id: :uuid do |t|
      t.references :restaurant, null: false, foreign_key: true, type: :uuid
      t.integer :status, default: 0 # enum: pending, processing, completed, failed
      t.decimal :total_amount, precision: 8, scale: 2, null: false
      t.integer :delivery_count, null: false
      t.datetime :processed_at
      t.string :stripe_payment_intent_id
      t.text :failure_reason
      
      t.timestamps
    end
    
    add_index :payment_batches, :status
    
    # Junction table for delivery requests in payment batches
    create_table :batch_deliveries, id: :uuid do |t|
      t.references :payment_batch, null: false, foreign_key: true, type: :uuid
      t.references :delivery_request, null: false, foreign_key: true, type: :uuid
      t.boolean :confirmed_by_restaurant, default: false
      t.datetime :confirmed_at
      
      t.timestamps
    end
    
    add_index :batch_deliveries, [:payment_batch_id, :delivery_request_id], unique: true, name: 'idx_batch_deliveries_unique'
    add_index :batch_deliveries, :confirmed_by_restaurant
    
    # Real-time location tracking for drivers
    create_table :driver_locations, id: :uuid do |t|
      t.references :driver, null: false, foreign_key: true, type: :uuid
      t.references :delivery_request, null: true, foreign_key: true, type: :uuid
      t.decimal :latitude, precision: 10, scale: 6, null: false
      t.decimal :longitude, precision: 10, scale: 6, null: false
      t.integer :accuracy_meters
      t.datetime :recorded_at, null: false
      
      t.timestamps
    end
    
    add_index :driver_locations, :recorded_at
  end
end