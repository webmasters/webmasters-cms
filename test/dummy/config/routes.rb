Rails.application.routes.draw do

  mount WebmastersCms::Engine => "/webmasters_cms"

  public_cms_pages
end
