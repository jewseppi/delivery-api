# Create admin user
admin = User.create!(
  email: 'admin@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  first_name: 'Admin',
  last_name: 'User',
  phone: '1234567890',
  role: 'admin'
)

# Create restaurant user
restaurant_user = User.create!(
  email: 'restaurant@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  first_name: 'Restaurant',
  last_name: 'Owner',
  phone: '1234567891',
  role: 'restaurant'
)

# Create driver user
driver_user = User.create!(
  email: 'driver@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  first_name: 'John',
  last_name: 'Driver',
  phone: '1234567892',
  role: 'driver'
)

puts "Created admin, restaurant, and driver users"