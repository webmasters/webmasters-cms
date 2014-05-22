module WebmastersCms
  class Engine < ::Rails::Engine
    isolate_namespace WebmastersCms
    
    config.generators do |g|
      g.orm :active_record
      g.template_engine :erb
      g.test_framework :rspec #, :fixture => true
      g.fixture_replacement :factory_girl, :dir => "spec/factories"
      g.view_specs false
    end
  end
end
