Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show, :update]
      resources :bets, only: [:index, :show, :create]
    end
  end

  get  '/topup', to: 'balance#index'
  post '/topup', to: 'balance#topup'

  root 'balance#index'

  get '/balance/confirm', to: 'balance#confirm'
  get '/balance/cancel', to: 'balance#cancel'
end

