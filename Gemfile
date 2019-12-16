source "https://rubygems.org"

# Declare your gem's dependencies in webmasters_cms.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec
gem 'passenger'
gem 'mysql2'
gem 'acts_as_versioned', git: 'https://github.com/hinagiku/acts_as_versioned.git'
gem 'sprockets', '< 4'

group :development do
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-rvm'
end

group :test do 
  gem 'rails-controller-testing'
  gem 'puma'
  gem 'rspec', git: 'https://github.com/rspec/rspec'
  gem 'rspec-core', git: 'https://github.com/rspec/rspec-core'
  gem 'rspec-expectations', git: 'https://github.com/rspec/rspec-expectations'
  gem 'rspec-mocks', git: 'https://github.com/rspec/rspec-mocks'
  gem 'rspec-rails', git: 'https://github.com/rspec/rspec-rails'
  gem 'rspec-support', git: 'https://github.com/rspec/rspec-support'
end
# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'
