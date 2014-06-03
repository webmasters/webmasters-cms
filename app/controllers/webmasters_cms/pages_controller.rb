require_dependency "webmasters_cms/application_controller"

module WebmastersCms
  class PagesController < ApplicationController
    def index
      @pages = Page.all
    end

    def show
      @page = Page.find(params[:id]) unless @page = Page.where(:local_path => params[:id]).first
    end

    def new
      @page = Page.new
    end

    def edit
      @page = Page.find(params[:id]) unless @page = Page.where(:local_path => params[:id]).first
    end

    def create
      @page = Page.new(page_params)
      if @page.save
        flash[:success] = "Page successfully created!"
        redirect_to @page
      else
        render 'new'
      end
    end

    def update
      @page = Page.find(params[:id])

      if @page.update(page_params)
        flash[:success] = "Page successfully updated!"
        redirect_to @page
      else
        render 'edit'
      end
    end

    def destroy
      @page = Page.find(params[:id])
      @page.destroy

      flash[:success] = "Page successfully deleted!"
      redirect_to pages_path
    end

    private
      def page_params
        params.required(:page).permit(:name, :title, :meta_description, :local_path, :body)
      end
  end
end
