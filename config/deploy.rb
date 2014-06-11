# encoding: utf-8
require "rvm/capistrano"
require 'bundler/capistrano'

set :application, "webmasters_cms"
set :rails_env, "production"

set :use_sudo, false
set :user, 'webmasters_cms'
set :repo_url, 'git@github.com:cgallitz/webmasters-cms.git'
set :branch, 'release'
set :scm, :git

set :deploy_to, "/var/www/apps/#{application}"
# set :deploy_via, :export

set :ssh_options, {:compression => true}
# is now the default
#set :rvm_type, :user
set :sql_dump_file, "#{shared_path}/dumps/webmasters_cms_production_#{Time.now.strftime("%Y_%m_%d__%H_%M_%S")}.sql"

set :staging_server, "ubuntu-test.nbg.webmasters.de"
#set :production_server, "www.wprin.org"

set :shared_children, %w(config dumps log pids)
set :target, nil

before :deploy do
  if target.nil?
    raise "Bitte ein Target (staging, production) zum Deployment angeben. " +
      "Beispiel: cap staging deploy"
  end
end

namespace :staging do
  desc 'set the staging environment'
  task :default do
    set :target, :staging
    server staging_server, :app, :web, :db, :primary => true
  end

  desc "Abort if app server is not staging"
  task :abort_unless_staging do
    if target != :staging
      raise "Dieser Task darf nur auf einem Staging-Server durchgeführt werden!"
    end
  end
end

namespace :production do
  desc 'set the production environment'
  task :default do
    set :target, :production
    server production_server, :app, :web, :db, :primary => true
  end

  desc "Abort if app server is not production"
  task :abort_unless_production do
    if target != :production
      raise "Dieser Task darf nur auf einem Production-Server durchgeführt werden!"
    end
  end
end

namespace :deploy do
  task :default do

    # erst nur den Code aktualisieren
    update_code

    db.create

    create_assets
    create_milestone_file

    deploy.migrate

    # Symlink erst vor dem Restart umbiegen
    create_symlink

    restart
  end

  # Passenger!
  task(:start) {}
  task(:stop) {}

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path, 'tmp', 'restart.txt')}"
    run "sudo /etc/init.d/apache2 reload"
  end

  task :finalize_update, :except => { :no_release => true } do
    run <<-CMD
      rm -rf #{release_path}/log &&
      ln -s #{shared_path}/log #{release_path}/log &&

      rm -f #{release_path}/config/database.yml &&
      ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml &&

      ln -s #{shared_path}/pids/ #{release_path}/tmp/pids
    CMD
  end

  desc "create asset files"
  task :create_assets do
    run("cd #{release_path}/test/dummy && bundle exec rake RAILS_ENV=#{rails_env} assets:precompile")
  end

  desc "Create a file with the milestone number"
  task :create_milestone_file do
    run "echo #{milestone} > #{release_path}/MILESTONE"
  end

  desc "Install rvm version"
  task :install_rvm do
    run "source ~/.bash_profile; rvm get stable --auto-dotfiles"
  end

  desc "Install ruby version"
  task :install_ruby_version do
    ruby_version = File.read('test/dummy/RUBY_VERSION').strip
    run "source ~/.bash_profile; if [[ $(rvm list strings | grep '#{ruby_version}') == '' ]]; then rvm install #{ruby_version} --disable-binary && rvm use #{ruby_version} --default && gem install bundler; fi"
    set :rvm_ruby_string, ruby_version

    set :default_shell do
      shell = File.join(rvm_bin_path, "rvm-shell")
      ruby = rvm_ruby_string.to_s.strip
      shell = "rvm_path=#{rvm_path} #{shell} '#{ruby}'" unless ruby.empty?
      shell
    end
  end

  desc "Install rubygem version"
  task :install_rubygem_version do
    run "source ~/.bash_profile && gem install -v #{File.read('test/dummy/GEM_VERSION').strip} rubygems-update && update_rubygems"
    run "source ~/.bash_profile && gem install bundler -v #{File.read('test/dummy/BUNDLER_VERSION').strip}"
  end

  desc "Builds the passenger module"
  task :build_passenger_apache_module do
    passenger_install = "bundle exec passenger-install-apache2-module"
    passenger_mod = "/etc/apache2/mods-available/passenger.load"
    to_release_path = "source ~/.bash_profile; cd #{release_path}"
    run "#{to_release_path}; if [ ! -f $(#{passenger_install} --snippet | grep LoadModule | awk '{print $3}') ]; then #{passenger_install} -a; fi"
  end

  desc "Updates the passenger module"
  task :update_passenger_apache_module do
    passenger_install = "bundle exec passenger-install-apache2-module"
    passenger_mod = "/etc/apache2/mods-available/passenger.load"
    to_release_path = "source ~/.bash_profile; cd #{release_path}"
    run "#{to_release_path}; snippet=$(#{passenger_install} --snippet); config=$(cat #{passenger_mod} | grep -v LoadModule | grep -v PassengerRoot | grep -v PassengerRuby | grep -v PassengerDefaultRuby | grep -v IfModule); echo \"$snippet\" > #{passenger_mod}; echo \"$config\" >> #{passenger_mod}"
  end
end

namespace :db do
  desc "Create Databases"
  task :create do
    run "cd #{release_path} && bundle exec rake db:create:all RAILS_ENV=#{rails_env}"
  end

  desc "Backup db"
  task :backup do
    run "cd #{release_path} && bundle exec rake app:webmasters_cms:dump_db[#{sql_dump_file}] RAILS_ENV=#{rails_env}"
  end
end

namespace :bundle do
  task :install do
    run "source ~/.bash_profile; cd #{release_path} && bundle install --path #{fetch(:bundle_dir, "#{shared_path}/bundle")} --deployment --without development test"
  end
end

before 'bundle:install', 'deploy:install_rvm', 'deploy:install_ruby_version',
  'deploy:install_rubygem_version'
after 'bundle:install', 'deploy:build_passenger_apache_module'
before 'deploy:restart', 'deploy:update_passenger_apache_module'