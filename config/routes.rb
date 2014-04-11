Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :users, only: [:show, :update]
      resources :bets, only: [:index, :show, :create]
    end
  end

  root to: "welcome#index"
end

