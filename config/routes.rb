WebmastersCms::Engine.routes.draw do

  resource :pages

  root 'pages#new'
end
