Rails.application.routes.draw do
  devise_for :users

  root 'homes#top'
  get 'homes/about'

  get 'posts/search' => 'posts#search'
  resources :posts

  resources :users, only: [:show, :edit, :update]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
