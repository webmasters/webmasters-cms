class AddIndexesRgtLftParentIdToWebmastersCmsPages < ActiveRecord::Migration
  def change
    add_index :webmasters_cms_pages, :rgt
    add_index :webmasters_cms_pages, :lft
    add_index :webmasters_cms_pages, :parent_id
    WebmastersCms::Page.rebuild!
  end
end
