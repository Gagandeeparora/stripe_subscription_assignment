Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :subscriptions, only: [:index, :create] do
    collection do
      get 'success'
      get 'failure'
    end
  end

  namespace :api do
    namespace :v1 do
      post '/stripe/stripe_events' => "stripe#stripe_events"
    end
  end

  # Defines the root path route ("/")
  root "subscriptions#index"
end
