Rails.application.routes.draw do
  resources :tipos_servicos
  root to: "static_pages#index"
  
  resources :users

  resources :despesas do
    get :produtos, on: :collection
    get :geral, on: :collection
    get :vale, on: :collection
    get :mensal, on: :collection

  end

  resources :servicos do
    get :todos, on: :collection
    get :mensal, on: :collection
    delete 'servicos/:id/apagar_foto', to: 'servicos#apagar_foto', as: :apagar_foto_servico

  end

  resources :financas do
    get :mensal, on: :collection
    get :individual, on: :collection
  end


  get 'entrar', to: 'sessions#new'
  post 'entrar', to: 'sessions#create'
  delete 'sair', to: 'sessions#destroy'

end
