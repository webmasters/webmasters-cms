class WebmastersCms::Railtie < Rails::Railtie # :nodoc:
  rake_tasks do
    Rake::Task['db:load_config'].enhance do
      migration_path = WebmastersCms::Engine.root.join('db', 'migrate').to_s
      unless ::ActiveRecord::Migrator.migrations_paths.include?(migration_path)
        ::ActiveRecord::Migrator.migrations_paths  << WebmastersCms::Engine.root.join('db', 'migrate').to_s
        ::ActiveRecord::Tasks::DatabaseTasks.migrations_paths = ::ActiveRecord::Migrator.migrations_paths
      end
    end
  end
end
