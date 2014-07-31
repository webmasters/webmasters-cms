class RemoveColumnsFromWebmastersCmsPages < ActiveRecord::Migration
  def change
    change_table :webmasters_cms_pages do |t|
      t.remove :name
      t.remove :local_path
      t.remove :title
      t.remove :meta_description
      t.remove :body
      t.remove :version
    end
  end
end
