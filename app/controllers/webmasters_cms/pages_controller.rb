require_dependency "webmasters_cms/application_controller"

module WebmastersCms
  class PagesController < ApplicationController
    extend WebmastersCms::PagesHelper
    use_cms_pages_layout
    helper_method :resource

    def index
    end

    def show
      redirect_to admin_pages_path unless resource
    end

    private
      def resource
        @resource ||= Page.where(:local_path => params[:local_path]).first
      end
  end
end
