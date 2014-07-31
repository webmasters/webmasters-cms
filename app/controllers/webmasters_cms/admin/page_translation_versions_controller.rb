require_dependency "webmasters_cms/application_controller"

module WebmastersCms
  module Admin
    class PageTranslationVersionsController < ApplicationController
      helper_method :page_translation, :collection, :collection_without_current_version

      def index
        page_translation
      end

      def show
        version = collection.where(version: params[:version]).first
        render partial: '/webmasters_cms/admin/pages/page', locals: {resource: version}
      end

      private
        def page_translation
          @page_translation ||= PageTranslation.find(params[:page_id])
        end

        def collection
          @collection ||= page_translation.versions
        end

        def collection_without_current_version
          collection.where.not(version: page_translation.version)
        end
    end
  end
end