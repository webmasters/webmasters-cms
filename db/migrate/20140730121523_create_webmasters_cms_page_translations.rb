class CreateWebmastersCmsPageTranslations < ActiveRecord::Migration
  def change
    create_table :webmasters_cms_page_translations do |t|
      t.string :name, null: false
      t.string :local_path, null: false
      t.string :title, null: false
      t.string :meta_description, null: false
      t.text :body, null: false
      t.string :language, null: false
      
      t.timestamps

      t.index :local_path, unique: true
      t.index :name, unique: true
    end
  end
end
