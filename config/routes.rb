Rollenspiel::Engine.routes.draw do
  resources :roles

  root to: 'roles#index'
end
