class AddColumnsRgtLftParentIdToPages < ActiveRecord::Migration[4.2]
  def change
    add_column :webmasters_cms_pages, :rgt, :integer
    add_column :webmasters_cms_pages, :lft, :integer
    add_column :webmasters_cms_pages, :parent_id, :integer
  end
end
