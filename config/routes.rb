WebmastersCms::Engine.routes.draw do
    namespace :admin do
      resources :pages
    end

    get ':local_path', as: 'local', to: 'pages#show'
    root :to => 'pages#index'
end
