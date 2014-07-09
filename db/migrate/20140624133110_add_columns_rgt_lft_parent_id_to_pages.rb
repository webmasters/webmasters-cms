class AddColumnsRgtLftParentIdToPages < ActiveRecord::Migration
  def change
    add_column :webmasters_cms_pages, :rgt, :integer
    add_column :webmasters_cms_pages, :lft, :integer
    add_column :webmasters_cms_pages, :parent_id, :integer
  end
end
