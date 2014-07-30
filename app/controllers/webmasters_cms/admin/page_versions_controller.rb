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

      private
      def page
        @page ||= PageTranslation.find(params[:page_id])
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