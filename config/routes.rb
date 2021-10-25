Rails.application.routes.draw do
  resources :user_stocks, only: %i[create destroy]
  resources :friendships, only: %i[create destroy]
  devise_for :users
  root "welcome#index"
  get "my_portfolio", to: "users#my_portfolio"
  get "search_stock", to: "stocks#search"
  get "friends", to: "users#my_friends"
  # delete "friends/:id", to: "friendships#unfollow"
  # post "friends", to: "friendships#follow"
  resources :users, only: %i[show]
  get "search_friends", to: "users#search"
end
