# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_08_08_183739) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "batch_deliveries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "payment_batch_id", null: false
    t.uuid "delivery_request_id", null: false
    t.boolean "confirmed_by_restaurant", default: false
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmed_by_restaurant"], name: "index_batch_deliveries_on_confirmed_by_restaurant"
    t.index ["delivery_request_id"], name: "index_batch_deliveries_on_delivery_request_id"
    t.index ["payment_batch_id", "delivery_request_id"], name: "idx_batch_deliveries_unique", unique: true
    t.index ["payment_batch_id"], name: "index_batch_deliveries_on_payment_batch_id"
  end

  create_table "delivery_requests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "restaurant_id", null: false
    t.uuid "driver_id"
    t.string "order_number", null: false
    t.text "order_notes"
    t.decimal "order_total", precision: 8, scale: 2
    t.text "pickup_address", null: false
    t.decimal "pickup_latitude", precision: 10, scale: 6
    t.decimal "pickup_longitude", precision: 10, scale: 6
    t.text "pickup_notes"
    t.text "delivery_address", null: false
    t.decimal "delivery_latitude", precision: 10, scale: 6
    t.decimal "delivery_longitude", precision: 10, scale: 6
    t.string "customer_name", null: false
    t.string "customer_phone", null: false
    t.text "delivery_notes"
    t.decimal "delivery_fee", precision: 6, scale: 2, null: false
    t.decimal "platform_fee", precision: 6, scale: 2, null: false
    t.decimal "driver_payout", precision: 6, scale: 2, null: false
    t.integer "status", default: 0
    t.datetime "requested_at", null: false
    t.datetime "assigned_at"
    t.datetime "picked_up_at"
    t.datetime "delivered_at"
    t.datetime "cancelled_at"
    t.decimal "estimated_distance_km", precision: 6, scale: 2
    t.integer "estimated_duration_minutes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_delivery_requests_on_driver_id"
    t.index ["order_number"], name: "index_delivery_requests_on_order_number", unique: true
    t.index ["requested_at"], name: "index_delivery_requests_on_requested_at"
    t.index ["restaurant_id"], name: "index_delivery_requests_on_restaurant_id"
    t.index ["status"], name: "index_delivery_requests_on_status"
  end

  create_table "driver_applications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "delivery_request_id", null: false
    t.uuid "driver_id", null: false
    t.integer "status", default: 0
    t.text "message"
    t.datetime "applied_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["delivery_request_id", "driver_id"], name: "idx_driver_applications_unique", unique: true
    t.index ["delivery_request_id"], name: "index_driver_applications_on_delivery_request_id"
    t.index ["driver_id"], name: "index_driver_applications_on_driver_id"
    t.index ["status"], name: "index_driver_applications_on_status"
  end

  create_table "driver_locations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "driver_id", null: false
    t.uuid "delivery_request_id"
    t.decimal "latitude", precision: 10, scale: 6, null: false
    t.decimal "longitude", precision: 10, scale: 6, null: false
    t.integer "accuracy_meters"
    t.datetime "recorded_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["delivery_request_id"], name: "index_driver_locations_on_delivery_request_id"
    t.index ["driver_id"], name: "index_driver_locations_on_driver_id"
    t.index ["recorded_at"], name: "index_driver_locations_on_recorded_at"
  end

  create_table "drivers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "license_number", null: false
    t.string "vehicle_make"
    t.string "vehicle_model"
    t.string "vehicle_year"
    t.string "vehicle_plate"
    t.decimal "current_latitude", precision: 10, scale: 6
    t.decimal "current_longitude", precision: 10, scale: 6
    t.integer "status", default: 0
    t.boolean "active", default: true
    t.decimal "rating", precision: 3, scale: 2, default: "5.0"
    t.integer "completed_deliveries", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["current_latitude", "current_longitude"], name: "index_drivers_on_current_latitude_and_current_longitude"
    t.index ["license_number"], name: "index_drivers_on_license_number", unique: true
    t.index ["rating"], name: "index_drivers_on_rating"
    t.index ["status"], name: "index_drivers_on_status"
    t.index ["user_id"], name: "index_drivers_on_user_id"
  end

  create_table "payment_batches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "restaurant_id", null: false
    t.integer "status", default: 0
    t.decimal "total_amount", precision: 8, scale: 2, null: false
    t.integer "delivery_count", null: false
    t.datetime "processed_at"
    t.string "stripe_payment_intent_id"
    t.text "failure_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_payment_batches_on_restaurant_id"
    t.index ["status"], name: "index_payment_batches_on_status"
  end

  create_table "payment_methods", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "restaurant_id", null: false
    t.string "stripe_payment_method_id", null: false
    t.string "card_last_four", null: false
    t.string "card_brand", null: false
    t.integer "exp_month", null: false
    t.integer "exp_year", null: false
    t.boolean "default", default: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["default"], name: "index_payment_methods_on_default"
    t.index ["restaurant_id"], name: "index_payment_methods_on_restaurant_id"
  end

  create_table "restaurants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "name", null: false
    t.string "business_license"
    t.text "address", null: false
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.string "city", null: false
    t.string "state", null: false
    t.string "zip_code", null: false
    t.string "stripe_customer_id"
    t.boolean "active", default: true
    t.json "business_hours", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_restaurants_on_active"
    t.index ["latitude", "longitude"], name: "index_restaurants_on_latitude_and_longitude"
    t.index ["user_id"], name: "index_restaurants_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "phone", null: false
    t.integer "role", default: 0
    t.boolean "active", default: true
    t.json "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["phone"], name: "index_users_on_phone", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "batch_deliveries", "delivery_requests"
  add_foreign_key "batch_deliveries", "payment_batches"
  add_foreign_key "delivery_requests", "drivers"
  add_foreign_key "delivery_requests", "restaurants"
  add_foreign_key "driver_applications", "delivery_requests"
  add_foreign_key "driver_applications", "drivers"
  add_foreign_key "driver_locations", "delivery_requests"
  add_foreign_key "driver_locations", "drivers"
  add_foreign_key "drivers", "users"
  add_foreign_key "payment_batches", "restaurants"
  add_foreign_key "payment_methods", "restaurants"
  add_foreign_key "restaurants", "users"
end
