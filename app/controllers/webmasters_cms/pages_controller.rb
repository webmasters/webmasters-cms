require_dependency "webmasters_cms/application_controller"

module WebmastersCms
  class PagesController < ApplicationController
    layout :cms_page_layout
    helper_method :resource

    def index
    end

    def show
      unless resource
        raise ActiveRecord::RecordNotFound
      end
    end

    def preview
      @resource = WebmastersCms::Page.new(page_params)
      render action: 'show'
    end

    private
      def resource
        @resource ||= Page.where(:local_path => params[:local_path]).first
      end

      def cms_page_layout
        "application"
      end

      def page_params
        params.required(:page).permit(:name, :title, :meta_description, :local_path, :body, :parent_id)
      end
  end
end
