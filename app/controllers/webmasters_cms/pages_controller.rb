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

    private
      def resource
        @resource ||= Page.where(:local_path => params[:local_path]).first
      end

      def cms_page_layout
        "application"
      end
  end
end
