Rails.application.routes.draw do
  devise_for :users
  root to: "lists#index"
  resources :recipes, except: :show do
    resources :ingredients, only: [:new, :create, :edit, :update, :destroy]
  end
  resources :lists, only: [:new, :index, :create, :destroy] do
    collection do
      get "select"
      post "random"
      post "all_random"
      delete "all_destroy"
    end
  end
end
