Rails.application.routes.draw do

  get  '/topup', to: 'balance#index'
  post '/topup', to: 'balance#topup'

  root 'welcome#index'

  post '/balance/confirm', to: 'balance#confirm'
  post '/balance/cancel', to: 'balance#cancel'
end
