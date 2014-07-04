require_dependency "webmasters_cms/application_controller"

module WebmastersCms
  module Admin
    class PagesController < ApplicationController
      layout "webmasters_cms/admin/application"
      helper_method :collection, :available_parent_pages, :resource

      def index
        collection
      end

      def show
        redirect_to admin_pages_path unless resource
      end

      def sort
        Page.update_parents(params[:page])
        render :nothing => true
      end

      def new
        @resource = Page.new
      end

      def edit
        unless resource
          flash[:error] = t :not_found, scope: [:activerecord, :flash, :error]
          redirect_to admin_pages_path
        end
      end

      def create
        @resource = Page.new(page_params)
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

      def list_versions
        resource
      end

      def set_current_version
        resource.save_without_revision
        flash[:success] = t :update, scope: [:activerecord, :flash, :success]
        redirect_to admin_page_path(resource)

        # render 'list_versions'
      end

      def preview_page_version
        #resource.reload
        #resource.revert_to(params[:version])
        version = resource.versions.where(:version => params[:version]).first
        render :partial => 'page', locals: {resource: version}
      end

      private
        def page_params
          params.required(:page).permit(:name, :title, :meta_description, :local_path, :body, :parent_id)
        end

        def collection
          @collection ||= Page.all
        end

        def resource
          params[:id] = params[:page_id] unless params[:id]
          @resource ||= Page.find(params[:id])
        end
    end
  end
end
