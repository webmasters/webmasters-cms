class MarkColumnsAsUnsignedForWebmastersCmsActiveLanguages < ActiveRecord::Migration
  
  def up
    change_table :webmasters_cms_active_languages do |t|
      t.change :id, :integer, :unsigned => true
    end
  end
  
  def down
    change_table :webmasters_cms_active_languages do |t|
      t.change :id, :integer, :unsigned => false
    end
  end
end
