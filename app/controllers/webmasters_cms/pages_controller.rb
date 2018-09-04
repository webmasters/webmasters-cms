require_dependency "webmasters_cms/application_controller"

module WebmastersCms
  class PagesController < ApplicationController
    layout :cms_page_layout
    helper_method :resource

    def index
    end

    def show
      if ActiveLanguage.find_by(code: language)
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
        @resource ||= collection_chain.find_by(local_path: local_path)
      end

      def collection_chain
        PageTranslation.joins(:page).where(language: language, Page.table_name => {:host_index => host_index})
      end

      def host_index
        Page.column_for_attribute(:host_index).default
      end

      def local_path
        params[:local_path] || ""
      end

      def language
        @language ||= params[:language] || I18n.locale
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
          !children_for_language.empty?
        
        if cond
          redirect_to_child
        elsif resource.redirect_to.present?
          redirect_to_page
        else
          show_page
        end
      end

      def redirect_to_child
        redirect_to children_for_language.first.local_path
      end

      def children_for_language
        @children_for_language ||= resource.page.children.first.translations.where(:language => resource.language)
      end

      def redirect_to_page
        redirect_to resource.redirect_to
      end

      def show_page
        render action: 'show'
      end
  end
end
