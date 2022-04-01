Rails.application.routes.draw do
  devise_for :users
  root to: "lists#index"
  resources :recipes, except: :show do
    resources :ingredients, only: [:new, :create, :edit, :update, :destroy]

    member do
      patch 'folder_in'
      delete 'folder_out'
    end
  end

  resources :lists, only: [:new, :index, :create, :destroy] do
    collection do
      post "random"
      delete "all_destroy"
    end
  end

  resources :shopping_lists, only: :index
  resources :folders do
    member do
      get 'add_recipe_select'
    end


  end

end
