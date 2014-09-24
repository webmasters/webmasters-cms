require_dependency "webmasters_cms/application_controller"

module WebmastersCms
  module Admin
    class PageTranslationVersionsController < ApplicationController
      layout :cms_page_layout
      helper_method :page_translation, :collection, :collection_without_current_version

      def index
        page_translation
      end

      def show
        version = collection.find_by(version: params[:version])
        render partial: 'page_translation_version_w_details', locals: { page_translation: version }
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

        def cms_page_layout
          "webmasters_cms/admin/application"
        end
    end
  end
end