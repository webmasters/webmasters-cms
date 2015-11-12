class MarkColumnsAsUnsignedForWebmastersCmsPages < ActiveRecord::Migration
  
  def up
    change_table :webmasters_cms_pages do |t|
      t.change :id, :integer, :unsigned => true
      t.change :rgt, :integer, :unsigned => true
      t.change :lft, :integer, :unsigned => true
      t.change :parent_id, :integer, :unsigned => true
    end
  end
  
  def down
    change_table :webmasters_cms_pages do |t|
      t.change :id, :integer, :unsigned => false
      t.change :rgt, :integer, :unsigned => false
      t.change :lft, :integer, :unsigned => false
      t.change :parent_id, :integer, :unsigned => false
    end
  end
end
