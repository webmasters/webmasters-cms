# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "webmasters_cms/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "webmasters_cms"
  s.version     = WebmastersCms::VERSION
  s.authors     = ["Christian Gallitzendörfer"]
  s.email       = ["c.gallitzendoerfer@webmasters.de"]
  s.homepage    = "http://www.webmasters.de"
  s.summary     = "CMS for Webmasters Akademie"
  s.description = "CMS for Webmasters Akademie"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "spec/factories/**/*" "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", ">= 5.0", "< 5.3"
  s.add_dependency "jquery-rails", ">= 2.1"
  s.add_dependency "jquery-ui-rails"
  s.add_dependency "jquery-mjs-nestedSortable-rails"

  s.add_dependency "awesome_nested_set"

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_bot_rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "selenium-webdriver"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "thor" # needed for rake db:migrate to work
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
end
