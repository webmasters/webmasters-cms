WebmastersCms::Engine.routes.draw do
    namespace :admin do
      resources :pages do
        put :sort, on: :collection
        resources :page_versions, path: :versions, as: :versions, only: [:index, :show] do
          patch :as_current_version
        end
      end
    end

    root :to => 'pages#index'
end
