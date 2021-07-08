Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  resources :dogs
  root to: "dogs#index"
  get '/dogs/:id/like', to: 'dogs#like', as: 'like_dog'
end
