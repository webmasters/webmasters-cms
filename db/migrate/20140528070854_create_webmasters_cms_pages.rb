class CreateWebmastersCmsPages < ActiveRecord::Migration
  def change
    create_table :webmasters_cms_pages do |t|
      t.string :name
      t.string :local_path
      t.string :title
      t.string :meta_description
      t.text :body

      t.timestamps
    end
    add_index :webmasters_cms_pages, :name, unique: true
    add_index :webmasters_cms_pages, :local_path, unique: true
  end
end
