WebmastersCms::Engine.routes.draw do

  resources :pages

  root 'pages#new'
end
