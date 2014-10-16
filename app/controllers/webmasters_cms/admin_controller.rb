require_dependency "webmasters_cms/application_controller"

module WebmastersCms
  class AdminController < ApplicationController
    helper 'webmasters_cms/admin/form'
  end
end
