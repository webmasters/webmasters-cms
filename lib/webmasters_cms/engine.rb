module WebmastersCms
  class Engine < ::Rails::Engine
    isolate_namespace WebmastersCms

    require 'awesome_nested_set'

    config.generators do |g|
      g.orm :active_record
      g.template_engine :erb
      g.test_framework :rspec, :fixture => false
      g.fixture_replacement :factory_girl, :dir => "spec/factories"
      g.assets false
      g.helper false
      g.view_specs false
    end
  end
end
