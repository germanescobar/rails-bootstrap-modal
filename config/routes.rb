Rails.application.routes.draw do
  root 'contacts#index'

  resources :contacts, only: [:new, :create]
end
