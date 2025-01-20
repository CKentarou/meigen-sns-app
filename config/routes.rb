Rails.application.routes.draw do
  get 'users/show'
  get 'users/edit'
  devise_for :users

  root 'homes#top'
  get 'homes/about'

  get 'posts/search' => 'posts#search'
  resources :posts

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
