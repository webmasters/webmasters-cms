WebmastersCms::Engine.routes.draw do
  # mount Ckeditor::Engine => '/ckeditor'
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

  resources :pages, only: [] do
    collection do
      match :preview, via: [:post, :patch]
    end
  end

  root :to => 'pages#index'
end
