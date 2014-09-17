module WebmastersCms
  module Extensions
    module Routing
      def public_cms_pages
        get ':language(/*local_path)', as: 'local', to: 'webmasters_cms/pages#show', format: false,
          constraints: {local_path: /[a-zA-Z0-9\-\_\/\.]+/, language: /[a-z]{2}/}
      end
    end
  end
end

ActionDispatch::Routing::Mapper.class_eval do
  include WebmastersCms::Extensions::Routing
end