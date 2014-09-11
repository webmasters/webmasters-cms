require_dependency "webmasters_cms/application_controller"

module WebmastersCms
  module Admin
    class PageTranslationsController < ApplicationController
      layout "webmasters_cms/admin/application"
      helper_method :collection, :available_parent_pages, :resource

      def index
        collection
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

      def destroy
        resource.destroy
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
          params.required(:page).permit(:title, :name, :local_path, :meta_description, :body, :language)
        end

        def collection
          @collection ||= Page.all
        end

        def resource
          # params[:id] = params[:page_id] unless params[:id]
          @resource ||= PageTranslation.find(params[:id])
        end
    end
  end
end