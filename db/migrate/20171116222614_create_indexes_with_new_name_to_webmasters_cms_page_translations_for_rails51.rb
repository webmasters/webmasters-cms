class CreateIndexesWithNewNameToWebmastersCmsPageTranslationsForRails51 < ActiveRecord::Migration[5.1]
  def up
    change_table do |t|
      t.index [:language, :name],
        :unique => true,
        :name => "index_rails_6bcc7f17f93f94d9d9ac700cdd964bb76271f117af256a24ba"
      t.index [:language, :local_path],
        :unique => true,
        :name => "index_rails_f244e57bf38531e0618a8daca55e425e02f7a9a50f6fcdecda"
      t.index [:page_id],
        :unique => false,
        :name => "index_rails_4629fc97ca42721a5046a209a4628166afd9c85b704a33048e"
      t.index [:language],
        :unique => false,
        :name => "index_rails_65e51d22ba2ff39d6cda11b1547087c8236643b51b2c40e89e"
      t.index [:soft_deleted],
        :unique => false,
        :name => "index_rails_84406cbb11c1e194c9a3108685e7a364f2d60d3fae9dbf63f5"
      t.index [:local_path],
        :unique => false,
        :name => "index_rails_8f8a6dada8e0fbed5e83814872245f667ee34bdb7e73c03323"
    end
  end

  def down
    change_table do |t|
      t.remove_index :name => "index_rails_6bcc7f17f93f94d9d9ac700cdd964bb76271f117af256a24ba"
      t.remove_index :name => "index_rails_f244e57bf38531e0618a8daca55e425e02f7a9a50f6fcdecda"
      t.remove_index :name => "index_rails_4629fc97ca42721a5046a209a4628166afd9c85b704a33048e"
      t.remove_index :name => "index_rails_65e51d22ba2ff39d6cda11b1547087c8236643b51b2c40e89e"
      t.remove_index :name => "index_rails_84406cbb11c1e194c9a3108685e7a364f2d60d3fae9dbf63f5"
      t.remove_index :name => "index_rails_8f8a6dada8e0fbed5e83814872245f667ee34bdb7e73c03323"
    end
  end

  private
  def change_table(&block)
    super :webmasters_cms_page_translations, &block
  end
end
