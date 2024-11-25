Rails.application.routes.draw do
  # Configure Devise routes with custom controllers
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations'
  }

  # Admin Routes
  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
  end

  # HR Routes
  namespace :hr do
    resources :documents, only: [:index, :edit]
  end

  # Standard Employee Routes
  resources :employees  # Use resources here for CRUD actions like edit, show, destroy

  # Employee Profile Route (if needed)
  namespace :employees do
    resource :profile, only: [:show]  # This seems like a profile page for the employee, not the full CRUD actions
  end

  # Custom Devise scope for logout (if required)
  devise_scope :user do
    get '/users/sign_out', to: 'devise/sessions#destroy'
  end

  # Root route
  root 'home#index'
 

  # Standard RESTful resources
  resources :documents
  resources :users, only: [:index, :show]

  # Public pages routes
  get 'about', to: 'pages#about_us'
  get 'contact', to: 'pages#contact_us'
  get 'privacy-policy', to: 'pages#privacy_policy'
  get 'terms-and-conditions', to: 'pages#terms_and_conditions'
end