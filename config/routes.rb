Rails.application.routes.draw do
  root to: "static_pages#index"
  
  resources :users

  resources :servicos do
    get :todos, on: :collection
  end

  get 'entrar', to: 'sessions#new'
  post 'entrar', to: 'sessions#create'
  delete 'sair', to: 'sessions#destroy'

end
