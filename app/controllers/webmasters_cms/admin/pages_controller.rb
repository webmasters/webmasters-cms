require_dependency "webmasters_cms/admin_controller"

module WebmastersCms
  module Admin
    class PagesController < AdminController
      layout :cms_page_layout
      helper_method :collection, :available_parent_pages, :resource, :translation, :get_languages

      def index
      end

      def sort
        klass.update_tree(params[:page])
        render :body => nil
      end

      def show
        redirect_to admin_pages_path unless translation
      end

      def new
        @resource = klass.new
        resource.translations.new
      end

      def edit
        unless resource
          flash[:error] = t :not_found, scope: [:activerecord, :pages, :flash, :error]
          render action: 'edit'
        end
      end

      def create
        @resource = klass.new(page_params)
        if resource.save
          flash[:success] = t :create, scope: [:activerecord, :pages, :flash, :success]
#          redirect_to admin_pages_path
          redirect_back fallback_location: { action: 'edit', id: resource.id },
            allow_other_host: false
        else
          flash[:error] = t :create, scope: [:activerecord, :pages, :flash, :error]
          render action: 'new'
        end
      end

      def update
        if resource.update(page_params)
          flash[:success] = t :update, scope: [:activerecord, :pages, :flash, :success]
#          redirect_to admin_pages_path
          redirect_back fallback_location: { action: 'edit', id: resource.id },
            allow_other_host: false
        else
          flash[:error] = t :update, scope: [:activerecord, :pages, :flash, :error]
          render action: "edit"
        end
      end

      def destroy
        resource.delete_node_keep_children
        flash[:success] = t :delete, scope: [:activerecord, :pages, :flash, :success]
        redirect_to admin_pages_path
      end

      def set_current_version
        if translation_resource.revert_to!(params[:page_translation][:version])
          flash[:success] = t :update, scope: [:activerecord, :flash, :success]
          redirect_to admin_pages_path
        else
          render :index
        end
      end

      private
        def klass
          Page
        end

        def page_params
          params.required(:page).permit(:parent_id, :rgt, :lft, :is_meta,
            translations_attributes: [:id ,:page_id, :title, :name, :local_path, 
              :meta_description, :body, :language, :show_in_navigation, :redirect_to_child, 
              :redirect_to, :menu_icon_css_class])
        end

        def collection
          @collection ||= klass.all
        end

        def resource
          @resource ||= klass.find(params[:id])
        end

        def translation
          @translation ||= resource.translations.find_by(language: params[:language])
        end

        def translation_resource
          @translation_resource ||= translation_klass.find(params[:id])
        end

        def translation_klass
          PageTranslation
        end

        def get_languages
          ::WebmastersCms::ActiveLanguage.all.collect { |l| [ l.name, l.code ] }
        end

        def cms_page_layout
          "webmasters_cms/admin/application"
        end
    end
  end
end
