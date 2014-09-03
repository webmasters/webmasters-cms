require_dependency "webmasters_cms/application_controller"

module WebmastersCms
  class PagesController < ApplicationController
    layout :cms_page_layout
    helper_method :resource

    def index
    end

    def show
      if ActiveLanguage.find_by(code: params[:language])
        unless resource
          raise ActiveRecord::RecordNotFound
        end
      else
        raise ActiveRecord::RecordNotFound
      end
    end

    def preview
      Page.connection.transaction do
        @resource = PageTranslation.new(translation_attributes_from_hash)
        render 'show'
        raise ActiveRecord::Rollback
      end
    end

    private
      def resource
        @resource ||= PageTranslation.where(language: params[:language]).find_by(local_path: params[:local_path])
      end

      def cms_page_layout
        "application"
      end

      def page_params
        params.required(:page).permit(:parent_id)
      end

      def translation_attributes_from_hash
        if params["page"] && params["page"]["translations_attributes"]
          params["page"]["translations_attributes"].values.detect do |attributes| 
            attributes["language"] == params["code"]
          end
        end
      end
  end
end
