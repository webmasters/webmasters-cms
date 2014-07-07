WebmastersCms::Engine.routes.draw do
    namespace :admin do
      resources :pages do
        member do
          patch :set_current_version
        end

        collection do
          put :sort
        end

        resources :page_versions, path: :versions, as: :versions, only: [:index, :show]
      end
    end

    root :to => 'pages#index'
end
