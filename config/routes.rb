Rails.application.routes.draw do

  root :to => 'messages#index'

  resources :messages

  post 'messages/prescription', to: 'messages#prescription', as: 'prescription'

end
