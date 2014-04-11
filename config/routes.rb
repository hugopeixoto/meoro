Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show, :create]
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  get  '/topup', to: 'balance#index'
  post '/topup', to: 'balance#topup'

  root 'welcome#index'

  post '/balance/confirm', to: 'balance#confirm'
  post '/balance/cancel', to: 'balance#cancel'
end
