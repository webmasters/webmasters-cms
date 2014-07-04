WebmastersCms::Engine.routes.draw do
    namespace :admin do
      resources :pages do
        put :sort, on: :collection
        get :versions, to: :list_versions
        patch :set_current_version
        get :preview_page_version
      end
    end

    root :to => 'pages#index'
end
