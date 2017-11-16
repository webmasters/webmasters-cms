class CreateWebmastersCmsPages < ActiveRecord::Migration[4.2]
  def change
    create_table :webmasters_cms_pages, :unsigned => false do |t|
      t.string :name
      t.string :local_path
      t.string :title
      t.string :meta_description
      t.text :body

      t.timestamps
    end
    add_index :webmasters_cms_pages, :name, unique: true,
      :name => 'index_webmasters_cms_pages_on_name'
    add_index :webmasters_cms_pages, :local_path, unique: true,
      :name => 'index_webmasters_cms_pages_on_local_path'
  end
end
