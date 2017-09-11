class AddIndexesRgtLftParentIdToWebmastersCmsPages < ActiveRecord::Migration[4.2]
  def change
    add_index :webmasters_cms_pages, :rgt
    add_index :webmasters_cms_pages, :lft
    add_index :webmasters_cms_pages, :parent_id
  end
end
