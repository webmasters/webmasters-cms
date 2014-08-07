require_dependency "webmasters_cms/application_controller"

module WebmastersCms
  module Admin
    class PageTranslationVersionsController < ApplicationController
      helper_method :page_translation, :collection, :collection_without_current_version

      def index
        page_translation
      end

      def show
        version = collection.find_by(version: params[:version])
        render '/webmasters_cms/admin/pages/page', resource: version
      end

      private
        def page_translation
          @page_translation ||= Page.find(params[:id]).translations.find_by(language: 1)
          # TODO params language
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