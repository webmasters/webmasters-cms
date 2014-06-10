WebmastersCms::Engine.routes.draw do
  namespace :admin do
    resources :pages
    root :to => 'pages#index'
  end
end
