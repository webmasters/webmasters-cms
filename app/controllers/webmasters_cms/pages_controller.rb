require_dependency "webmasters_cms/application_controller"

module WebmastersCms
  class PagesController < ApplicationController
    def new
      @page = Page.new
    end

    def create
      @page = Page.new(page_params)
      if @page.save
        redirect_to @page
      else
        render 'new'
      end
    end

    private
      def page_params
        params.required(:page).permit(:name, :title, :meta_description, :local_path, :body)
      end
  end
end
