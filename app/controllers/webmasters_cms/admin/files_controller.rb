require_dependency "webmasters_cms/application_controller"

module WebmastersCms
  class Admin::FilesController < AdminController

    def create
      build_resource

      if resource.save
        file = resource.file;
        render :json => {:fileName => file.original_filename, :uploaded => true, :url => file.url}
      else
        render :json => {:uploaded => false, 
          :error => {:number => Rack::Utils::SYMBOL_TO_STATUS_CODE[:accepted],
                     :message => resource.errors.full_messages.join('; ')}}
      end
    end

    private
    def build_resource
      resource.file = params[:upload]
      resource
    end

    def resource
      @resource ||= ::WebmastersCms::File.new
    end
  end
end
