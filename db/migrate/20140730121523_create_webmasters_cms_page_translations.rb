class CreateWebmastersCmsPageTranslations < ActiveRecord::Migration[4.2]
  def change
    create_table :webmasters_cms_page_translations, :unsigned => false do |t|
      t.string :name, :local_path, :title, :meta_description, :language, null: false
      t.text :body, null: false
      t.integer :version, :page_id, null: false, default: 0, :unsigned => false
      
      t.timestamps

      t.index :local_path, unique: true
      t.index :name, unique: true
    end
  end
end
