WebmastersCms::Engine.routes.draw do
    namespace :admin do
      resources :pages
    end

    root :to => 'pages#index'
end
