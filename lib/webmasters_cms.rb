require 'webmasters_cms/railtie'
require "webmasters_cms/engine"
require "webmasters_cms/extensions/routing"

module WebmastersCms
end

# manual requiring of jquery gems as work-around because it did not work automatically
require 'jquery-rails' unless defined? Jquery::Rails
require 'jquery-ui-rails' unless defined? Jquery::Ui
require 'jquery/mjs/nestedSortable/rails' unless defined? Jquery::Mjs::NestedSortable::Rails::Engine
