class AddVersionToWebmastersCmsPages < ActiveRecord::Migration
  def change
    add_column :webmasters_cms_pages, :version, :integer
  end
end
