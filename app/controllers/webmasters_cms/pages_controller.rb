require_dependency "webmasters_cms/application_controller"

module WebmastersCms
  class PagesController < ApplicationController
    def new
      @page = Page.new
    end
  end
end
