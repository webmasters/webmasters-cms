require_dependency "webmasters_cms/application_controller"

module WebmastersCms
  module Admin
    class PagesController < ApplicationController
      layout "webmasters_cms/admin/application"
      helper_method :collection, :available_parent_pages, :resource, :translation

      def index
      end

      def sort
        klass.update_tree(params[:page])
        render :nothing => true
      end

      def show
        redirect_to admin_pages_path unless resource
      end

      def new
        @resource = klass.new
        resource.translations.new
      end

      def edit
        unless resource
          flash[:error] = t :not_found, scope: [:activerecord, :pages, :flash, :error]
          redirect_to admin_pages_path
        end
      end

      def create
        @resource = klass.create(page_params)
        if resource.save
          flash[:success] = t :create, scope: [:activerecord, :pages, :flash, :success]
          redirect_to admin_pages_path
        else
          render 'new'
        end
      end

      def update
        if resource.update(page_params)
          flash[:success] = t :update, scope: [:activerecord, :pages, :flash, :success]
          redirect_to admin_pages_path
        else
          render 'edit'
        end
      end

      def destroy
        resource.destroy
        flash[:success] = t :delete, scope: [:activerecord, :pages, :flash, :success]
        redirect_to admin_pages_path
      end

      private
        def klass
          Page
        end

        def page_params
          params.required(:page).permit(:parent_id, :rgt, :lft,
            translations_attributes: [:id ,:page_id, :title, :name, :local_path, :meta_description, :body, :language, :_destroy])
        end

        def collection
          @collection ||= klass.all
        end

        def resource
          params[:id] = params[:page_id] unless params[:id]
          @resource ||= klass.find(params[:id])
        end

        def translation
          @translation ||= resource.translations.find_by(language: params[:locale])
        end
    end
  end
end