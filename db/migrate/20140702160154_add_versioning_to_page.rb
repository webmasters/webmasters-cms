class AddVersioningToPage < ActiveRecord::Migration[4.2]
  def change
    create_table :webmasters_cms_page_versions, :unsigned => false do |t|
      t.integer  :page_id, :unsigned => false
      t.integer  :version, :unsigned => false
      t.string   :name
      t.string   :local_path
      t.string   :title
      t.string   :meta_description
      t.text     :body
      t.timestamps
    end

    add_index :webmasters_cms_page_versions, [:page_id], name: :index_webmasters_cms_page_versions_on_page_id
  end
end
