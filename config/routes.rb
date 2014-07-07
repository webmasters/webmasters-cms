WebmastersCms::Engine.routes.draw do
    namespace :admin do
      resources :pages do
        put :sort, on: :collection
        patch :set_current_version
        resources :page_versions, path: :versions, as: :versions, only: [:index, :show]
      end
    end

    root :to => 'pages#index'
end
