require_dependency "webmasters_cms/application_controller"

module WebmastersCms
  class PagesController < ApplicationController
    helper_method :resource

    def show
      redirect_to admin_pages_path unless resource
    end

    private
      def resource
        @resource ||= Page.where(:local_path => params[:local_path]).first
      end
  end
end
