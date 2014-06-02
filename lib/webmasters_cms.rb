require "webmasters_cms/engine"

module WebmastersCms
end

# manual requiring of jquery-rails as work-around because it did not work automatically
require 'jquery-rails' unless defined? Jquery::Rails