Rails.application.routes.draw do
  # Health check
  get '/health', to: proc { [200, {}, ['OK']] }
  
  # Authentication routes
  post '/auth/login', to: 'auth#login'
  post '/auth/register', to: 'auth#register'
  post '/auth/refresh', to: 'auth#refresh'
  delete '/auth/logout', to: 'auth#logout'
  
  namespace :api do
    namespace :v1 do
      resources :delivery_requests do
        member do
          post :assign_driver
          post :pickup
          post :deliver
          post :cancel
        end
        
        collection do
          get :available
        end
      end
    end
  end
end