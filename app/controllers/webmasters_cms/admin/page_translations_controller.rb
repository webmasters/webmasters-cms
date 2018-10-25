require_dependency "webmasters_cms/admin_controller"

module WebmastersCms
  module Admin
    class PageTranslationsController < AdminController
      layout :cms_page_layout
      helper_method :collection, :collection_of_deleted_translations, :available_parent_pages, :resource

      def index
        collection
      end

      def deleted_translations
        collection_of_deleted_translations
      end

      def show
        redirect_to admin_pages_path unless resource
      end

      def new
        @resource = PageTranslation.new(page_params)
      end

      def edit
        unless resource
          flash[:error] = t :not_found, scope: [:activerecord, :flash, :error]
          redirect_to admin_pages_path
        end
      end

      def create
        @resource = resource.translations.create(page_params)
        if resource.save
          flash[:success] = t :create, scope: [:activerecord, :flash, :success]
          redirect_to admin_pages_path
        else
          render 'new'
        end
      end

      def update
        if resource.update(page_params)
          flash[:success] = t :update, scope: [:activerecord, :flash, :success]
          redirect_to admin_page_path(resource)
        else
          render 'edit'
        end
      end

      def soft_delete
        resource.update(soft_deleted: true)
        flash[:success] = t :delete, scope: [:activerecord, :flash, :success]
        redirect_to admin_pages_path
      end

      def undelete
        deleted_resource.update(soft_deleted: false)
        flash[:success] = t :undelete, scope: [:activerecord, :flash, :success]
        redirect_to admin_pages_path
      end

      def destroy
        deleted_resource.destroy
        flash[:success] = t :delete, scope: [:activerecord, :flash, :success]
        redirect_to admin_pages_path
      end

      def set_current_version
        if resource.revert_to!(params[:page][:version])
          flash[:success] = t :update, scope: [:activerecord, :flash, :success]
          redirect_to admin_page_path(resource)
        else
          render :index
        end
      end

      private
        def page_params
          params.required(:page).permit(:title, :name, :local_path, :meta_description, :body, :language, :show_in_navigation, :redirect_to_child, :redirect_to)
        end

        def collection
          @collection ||= page_klass.all
        end

        def page_klass
          Page
        end

        def collection_of_deleted_translations
          @collection_of_deleted_translations ||= klass.all.where(soft_deleted: true)
        end

        def resource
          @resource ||= klass.find_by(id: params[:id], soft_deleted: false)
        end

        def deleted_resource
          @deleted_resource ||= klass.find_by(id: params[:id], soft_deleted: true)
        end

        def klass
          PageTranslation
        end

        def cms_page_layout
          "webmasters_cms/admin/application"
        end
    end
  end
end
