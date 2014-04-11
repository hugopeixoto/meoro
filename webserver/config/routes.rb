Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:show, :update]
      resources :bets, only: [:index, :show, :create]
    end
  end

  get  '/topup', to: 'balance#index'
  post '/topup', to: 'balance#topup'

  get '/balance/confirm', to: 'balance#confirm'
  get '/balance/cancel', to: 'balance#cancel'

  root to: "welcome#index"
end

