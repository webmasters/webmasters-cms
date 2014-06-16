# encoding: utf-8
require "rvm/capistrano"

set :application, "webmasters_cms"
set :rails_env, "production"

set :use_sudo, false
set :user, 'webmasters_cms'
set :repo_url, 'git@github.com:cgallitz/webmasters-cms.git'
set :branch, 'release'
set :scm, :git

 set :deploy_to, "/var/www/apps/#{fetch(:application)}"
# set :deploy_via, :export

set :ssh_options, {:compression => true}
# is now the default
#set :rvm_type, :user
set :sql_dump_file, "#{fetch(:shared_path)}/dumps/webmasters_cms_production_#{Time.now.strftime("%Y_%m_%d__%H_%M_%S")}.sql"

set :shared_children, %w(config dumps log pids)
set :application_path, "#{release_path}/test/dummy"

namespace :staging do
  desc "Abort if app server is not staging"
  task :abort_unless_staging do
    if target != :staging
      raise "Dieser Task darf nur auf einem Staging-Server durchgeführt werden!"
    end
  end
end

namespace :production do
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

  task :setup do
    on release_roles :all do
      fetch(:shared_children).each do |child_path|
        path = shared_path.join(child_path)
        execute :mkdir, '-p', path
      end
    end
  end

  desc "Check that we can access everything"
  task :check_write_permissions do
    on roles(:all) do |host|
      if test("[ -w #{fetch(:deploy_to)} ]")
        info "#{fetch(:deploy_to)} is writable on #{host}"
      else
        error "#{fetch(:deploy_to)} is not writable on #{host}"
      end
    end
  end

  # Passenger!
  task(:start) {}
  task(:stop) {}

# task :restart, :roles => :app, :except => { :no_release => true } do
  task :restart do
    execute :touch, "#{File.join(current_path, 'tmp', 'restart.txt')}"
    execute "sudo /etc/init.d/apache2 reload"
  end

# task :finalize_update, :except => { :no_release => true } do
  task :finalize_update do
    execute :rm, "-rf", "#{fetch(:application_path)}/log"
    execute :ln, "-s", "#{shared_path}/log #{fetch(:application_path)}/log"
    execute :rm, "-f", "#{fetch(:application_path)}/config/database.yml"
    execute :ln, "-s", "#{shared_path}/config/database.yml #{fetch(:application_path)}/config/database.yml"
    execute :ln, "-s", "#{shared_path}/pids/ #{fetch(:application_path)}/tmp/pids"
  end

  desc "create asset files"
  task :create_assets do
    within "#{fetch(:application_path)}" do
      with rails_env: fetch(:rails_env) do
        execute :rake, "assets:precompile"
      end
    end
  end

  desc "Create a file with the milestone number"
  task :create_milestone_file do
    execute "echo #{milestone} > #{fetch(:application_path)}/MILESTONE"
  end

  desc "Install rvm version"
  task :install_rvm do
    execute "source ~/.bash_profile; rvm get stable --auto-dotfiles"
  end

  desc "Install ruby version"
  task :install_ruby_version do
    ruby_version = File.read('test/dummy/RUBY_VERSION').strip
    execute "source ~/.bash_profile; if [[ $(rvm list strings | grep '#{ruby_version}') == '' ]]; then rvm install #{ruby_version} --disable-binary && rvm use #{ruby_version} --default && gem install bundler; fi"
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
    execute "source ~/.bash_profile && gem install -v #{File.read('test/dummy/GEM_VERSION').strip} rubygems-update && update_rubygems"
    execute "source ~/.bash_profile && gem install bundler -v #{File.read('test/dummy/BUNDLER_VERSION').strip}"
  end

  desc "Builds the passenger module"
  task :build_passenger_apache_module do
    passenger_install = "bundle exec passenger-install-apache2-module"
    passenger_mod = "/etc/apache2/mods-available/passenger.load"
    to_release_path = "source ~/.bash_profile; cd #{fetch(:application_path)}"
    execute "#{to_release_path}; if [ ! -f $(#{passenger_install} --snippet | grep LoadModule | awk '{print $3}') ]; then #{passenger_install} -a; fi"
  end

  desc "Updates the passenger module"
  task :update_passenger_apache_module do
    passenger_install = "bundle exec passenger-install-apache2-module"
    passenger_mod = "/etc/apache2/mods-available/passenger.load"
    to_release_path = "source ~/.bash_profile; cd #{fetch(:application_path)}"
    execute "#{to_release_path}; snippet=$(#{passenger_install} --snippet); config=$(cat #{passenger_mod} | grep -v LoadModule | grep -v PassengerRoot | grep -v PassengerRuby | grep -v PassengerDefaultRuby | grep -v IfModule); echo \"$snippet\" > #{passenger_mod}; echo \"$config\" >> #{passenger_mod}"
  end
end

namespace :db do
  desc "Create Databases"
  task :create do
    within fetch(:application_path) do
      with rails_env: fetch(:rails_env) do
        execute :rake, "db:create:all"
      end
    end
  end

  desc "Backup db"
  task :backup do
    within fetch(:application_path) do
      with rails_env: fetch(:rails_env) do
        execute :rake, "app:webmasters_cms:dump_db[#{fetch(:sql_dump_file)}]"
      end
    end
  end
end

namespace :bundle do
  task :install do
    execute "source ~/.bash_profile; cd #{fetch(:application_path)} && bundle install --path #{fetch(:bundle_dir, "#{shared_path}/bundle")} --deployment --without development test"
  end
end

before 'bundle:install', 'deploy:install_rvm', 'deploy:install_ruby_version',
  'deploy:install_rubygem_version'
after 'bundle:install', 'deploy:build_passenger_apache_module'
before 'deploy:restart', 'deploy:update_passenger_apache_module'