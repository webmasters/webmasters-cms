WebmastersCms::Engine.routes.draw do
    namespace :admin do
      resources :pages do
        put :sort, on: :collection
      end
    end

    root :to => 'pages#index'
end
