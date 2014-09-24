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
        if active_redirect?
          @resource = redirected_resource
        else
          @resource ||= PageTranslation.where(language: params[:language]).find_by(local_path: params[:local_path] || "")
        end
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

      def active_redirect?
        params[:local_path] ||= ""
        translation = PageTranslation.find_by(language: params[:language], local_path: params[:local_path])
        translation.redirect_to.present? || translation.redirect_to_child
      end

      def redirected_resource
        translation = PageTranslation.find_by(language: params[:language], local_path: params[:local_path])
        if translation.redirect_to.present?
          PageTranslation.find_by(language: translation.language, local_path: translation.redirect_to)
        elsif translation.redirect_to_child
          child_page = Page.first_child_of_page(translation.page_id)
          PageTranslation.find_by(page_id: child_page.id, language: translation.language)
        end
      end
  end
end
