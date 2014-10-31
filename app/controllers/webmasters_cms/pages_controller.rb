require_dependency "webmasters_cms/application_controller"

module WebmastersCms
  class PagesController < ApplicationController
    layout :cms_page_layout
    helper_method :resource

    def index
    end

    def show
      if ActiveLanguage.find_by(code: params[:language])
        if resource
          redirect_or_show_page
        else
          raise ActiveRecord::RecordNotFound
        end
      else
        raise ActiveRecord::RecordNotFound
      end
    end

    def preview
      Page.transaction do
        @resource = PageTranslation.new(translation_attributes_from_hash)
        show_page
        raise ActiveRecord::Rollback
      end
    end

    private
      def resource
        @resource ||= PageTranslation.where(language: params[:language]).find_by(local_path: params[:local_path] || "")
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

      def redirect_or_show_page
        cond = resource.redirect_to_child && !resource.page.children.empty? && 
          !resource.page.children.first.translations.where(:language => resource.language).empty?
        
        if cond
          redirect_to_child
        elsif resource.redirect_to.present?
          redirect_to_page
        else
          show_page
        end
      end

      def redirect_to_child
        redirect_to resource.page.children.first.translations.where(:language => resource.language).first.local_path
      end

      def redirect_to_page
        redirect_to resource.redirect_to
      end

      def show_page
        render action: 'show'
      end
  end
end
