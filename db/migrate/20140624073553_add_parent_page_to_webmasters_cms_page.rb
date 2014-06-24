class AddParentPageToWebmastersCmsPage < ActiveRecord::Migration
  def change
    add_column :webmasters_cms_pages, :parent_page, :string
  end
end
