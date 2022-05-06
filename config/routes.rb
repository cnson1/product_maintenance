Rails.application.routes.draw do
  get 'admin/index'
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :logout
  end
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  resources :users
  root 'store#index', as: 'store_index'
  resources :products
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
