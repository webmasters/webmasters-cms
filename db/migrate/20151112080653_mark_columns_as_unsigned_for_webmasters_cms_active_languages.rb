class MarkColumnsAsUnsignedForWebmastersCmsActiveLanguages < ActiveRecord::Migration
  
  def up
    change_table :webmasters_cms_active_languages do |t|
      t.change :id, :integer, :null => false, :auto_increment => true, :unsigned => true
    end
  end
  
  def down
    change_table :webmasters_cms_active_languages do |t|
      t.change :id, :integer, :null => false, :auto_increment => true, :unsigned => false
    end
  end
end
