Rails.application.routes.draw do
  root to: "static_pages#index"
  resources :logo_imagems do
    delete 'logo_imagems/:id/apagar_foto', to: 'logo_imagems#apagar_foto', as: :apagar_foto_logo_imagem
  end
  
  resources :tipos_servicos
  
  resources :users do
    get :json_teste, on: :collection
  end

  resources :despesas do
    get :produtos, on: :collection
    get :geral, on: :collection
    get :vale, on: :collection
    get :mensal, on: :collection

  end

  resources :servicos do
    get :todos, on: :collection
    get :mensal, on: :collection
    get :recibo
    
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
