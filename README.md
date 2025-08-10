# Delivery App - Rails API Backend

A RESTful API backend built with Ruby on Rails for managing food delivery services, supporting restaurant and driver operations.

## 🚀 Features

### Authentication

- ✅ User registration and login
- ✅ JWT token-based authentication
- ✅ Role-based access control (Restaurant/Driver)
- ✅ Secure password handling with bcrypt

### Delivery Management

- ✅ Create and manage delivery requests
- ✅ Real-time status updates
- ✅ Driver assignment system
- ✅ Order tracking and history
- ✅ Customer information management

### API Endpoints

- ✅ RESTful API design
- ✅ JSON API responses
- ✅ Proper HTTP status codes
- ✅ Error handling and validation
- ✅ CORS support for frontend integration

## 🛠️ Tech Stack

- **Ruby on Rails 7.x** - Web framework
- **PostgreSQL** - Database (production)
- **SQLite** - Database (development)
- **bcrypt** - Password encryption
- **JWT** - Authentication tokens
- **Rack CORS** - Cross-origin requests
- **Puma** - Web server

## 📋 API Endpoints

### Authentication

```
POST   /auth/login          # User login
POST   /auth/register       # User registration
GET    /auth/me            # Get current user
```

### Delivery Requests

```
GET    /api/v1/delivery_requests          # List all deliveries
POST   /api/v1/delivery_requests          # Create new delivery
GET    /api/v1/delivery_requests/:id      # Get specific delivery
PUT    /api/v1/delivery_requests/:id      # Update delivery
DELETE /api/v1/delivery_requests/:id      # Delete delivery
```

### Driver Operations

```
GET    /api/v1/delivery_requests?status=pending    # Available deliveries
POST   /api/v1/delivery_requests/:id/accept        # Accept delivery
PUT    /api/v1/delivery_requests/:id/status        # Update status
```

## 🔧 Setup & Installation

### Prerequisites

- Ruby 3.x
- Rails 7.x
- PostgreSQL (for production)
- Bundler

### Installation

```bash
# Clone the repository
git clone https://github.com/jewseppi/delivery-api.git
cd delivery-api

# Install dependencies
bundle install

# Setup database
rails db:create
rails db:migrate
rails db:seed

# Start the server
rails server
```

The API will be available at `http://localhost:3000`

### Database Setup

```bash
# Create and migrate database
rails db:create db:migrate

# Seed with sample data (optional)
rails db:seed

# Reset database (if needed)
rails db:drop db:create db:migrate db:seed
```

## 🏗️ Project Structure

```
app/
├── controllers/        # API controllers
│   ├── auth_controller.rb
│   └── api/v1/
│       └── delivery_requests_controller.rb
├── models/            # Data models
│   ├── user.rb
│   ├── delivery_request.rb
│   └── order_item.rb
├── serializers/       # JSON response formatting
└── middleware/        # Custom middleware

config/
├── routes.rb         # API routes
├── database.yml      # Database configuration
└── cors.rb          # CORS settings

db/
├── migrate/         # Database migrations
└── seeds.rb        # Sample data
```

## 🔐 Authentication

The API uses JWT tokens for authentication. Include the token in requests:

```bash
# Login to get token
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "restaurant@example.com", "password": "password123"}'

# Use token in subsequent requests
curl -X GET http://localhost:3000/api/v1/delivery_requests \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## 📊 Database Schema

### Users Table

- `id` - Primary key
- `email` - Unique email address
- `password_digest` - Encrypted password
- `first_name` - User's first name
- `last_name` - User's last name
- `phone` - Contact number
- `role` - User role (restaurant/driver)
- `active` - Account status

### Delivery Requests Table

- `id` - Primary key
- `order_number` - Unique order identifier
- `restaurant_id` - Foreign key to users
- `driver_id` - Foreign key to users (nullable)
- `customer_name` - Customer information
- `customer_phone` - Customer contact
- `customer_address` - Delivery address
- `pickup_address` - Restaurant address
- `status` - Order status enum
- `total_amount` - Order total
- `delivery_fee` - Delivery cost
- `timestamps` - Created/updated times

## 🧪 Testing

```bash
# Run all tests
rails test

# Run specific test file
rails test test/controllers/delivery_requests_controller_test.rb

# Run with coverage
COVERAGE=true rails test
```

## 🚀 Deployment

### Heroku Deployment

```bash
# Create Heroku app
heroku create delivery-api-production

# Set environment variables
heroku config:set RAILS_MASTER_KEY=your_master_key

# Deploy
git push heroku main

# Run migrations
heroku run rails db:migrate
```

### Environment Variables

```bash
# Required for production
RAILS_MASTER_KEY=your_master_key
DATABASE_URL=your_database_url
JWT_SECRET=your_jwt_secret
CORS_ORIGINS=https://your-frontend-domain.com
```

## 📈 Development

### Sample API Calls

```bash
# Create a delivery request
curl -X POST http://localhost:3000/api/v1/delivery_requests \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "delivery_request": {
      "order_number": "ORD123",
      "customer_name": "John Doe",
      "customer_phone": "555-1234",
      "customer_address": "123 Main St",
      "total_amount": 25.99,
      "delivery_fee": 3.99
    }
  }'

# Update delivery status
curl -X PUT http://localhost:3000/api/v1/delivery_requests/1 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{"delivery_request": {"status": "assigned"}}'
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support, email your-email@example.com or create an issue in this repository.

---

Built with ❤️ using Ruby on Rails
