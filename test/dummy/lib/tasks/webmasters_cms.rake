namespace :webmasters_cms do
  desc "dump a rails database"
  task :dump_db, [:out_file] => [:environment] do |t, args|
    if db_config = ActiveRecord::Base.configurations[Rails.env]
      db_name = db_config['database']
      out_file = args[:out_file] || "/tmp/#{Time.now.strftime("%Y_%m_%d")}__#{db_name}.sql"
      p "Dumping #{db_name} to #{out_file}"

      command = ['mysqldump']
      command << '-u'
      command << db_config['username']
      command << "-p#{db_config['password']}" unless db_config['password'].blank?
      command << db_name
      command << '>'
      command << out_file

      system command.join(' ')
    end
  end

  desc "import a rails database dump"
  task :import_db_dump, [:import_file] => ["db:drop", "db:create", :environment] do |t, args|
    if db_config = ActiveRecord::Base.configurations[Rails.env]
      db_name = db_config['database']
      import_file = args[:import_file]
      p "Importing #{import_file} to #{db_name}"

      command = ['mysql']
      command << '-u'
      command << db_config['username']
      command << "-p#{db_config['password']}" unless db_config['password'].blank?
      command << db_name
      command << '<'
      command << import_file

      system command.join(' ')
    end
  end
end