WebmastersCms::Engine.routes.draw do
  resources :pages, :path => ''
  get ':local_path', to: "pages#show"
  root :to => 'pages#index'
end
