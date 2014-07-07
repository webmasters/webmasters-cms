require_dependency "webmasters_cms/application_controller"

module WebmastersCms
  module Admin
    class PageVersionsController < ApplicationController
      helper_method :page, :collection, :collection_without_current_version

      def index
        page
      end

      def show
        version = collection.where(version: params[:version]).first
        render partial: '/webmasters_cms/admin/pages/page', locals: {resource: version}
      end

      def as_current_version
        if page.revert_to!(params[:page][:version])
          flash[:success] = t :update, scope: [:activerecord, :flash, :success]
          redirect_to admin_page_path(page)
        else
          render :index
        end
      end

      private
      def page
        @page ||= Page.find(params[:page_id])
      end

      def collection
        @collection ||= page.versions
      end

      def collection_without_current_version
        collection.where.not(version: page.version)
      end
    end
  end
end