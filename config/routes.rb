# config/routes.rb
Rails.application.routes.draw do
  get "payments/create"
  get "products/index"
  get "products/new"
  get "products/edit"
  devise_for :users

  # Root page
  root to: "pages#home"
  get "pages/home"
  resources :products
  resources :payments, only: [:create] do
    collection do
      get :success
      get :cancel
    end
  end

  # Departments
  get "departments", to: "departments#index"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA routes
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
