Rails.application.routes.draw do

  mount WebmastersCms::Engine => "/webmasters_cms"
  get ':local_path', as: 'local', to: 'webmasters_cms/pages#show'
end
