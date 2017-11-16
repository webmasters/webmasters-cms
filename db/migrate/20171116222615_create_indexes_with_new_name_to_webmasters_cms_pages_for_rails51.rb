class CreateIndexesWithNewNameToWebmastersCmsPagesForRails51 < ActiveRecord::Migration[5.1]
  def up
    change_table do |t|
      t.index [:rgt],
        :unique => false,
        :name => "index_rails_8dde03030edc7be390b2a04aee530ca052e0e69a618ef6162d"
      t.index [:lft],
        :unique => false,
        :name => "index_rails_ae6c3a836b7590b6aa40729dd26cadfe069994230b7045945a"
      t.index [:parent_id],
        :unique => false,
        :name => "index_rails_a2d564f7616879db19d943a1f651b4cd5747505295c0abc2ac"
      t.index [:is_meta],
        :unique => false,
        :name => "index_rails_42711403a23f14dddfa0e74ab1afffc2e5522e658885fffa7b"
    end
  end

  def down
    change_table do |t|
      t.remove_index :name => "index_rails_8dde03030edc7be390b2a04aee530ca052e0e69a618ef6162d"
      t.remove_index :name => "index_rails_ae6c3a836b7590b6aa40729dd26cadfe069994230b7045945a"
      t.remove_index :name => "index_rails_a2d564f7616879db19d943a1f651b4cd5747505295c0abc2ac"
      t.remove_index :name => "index_rails_42711403a23f14dddfa0e74ab1afffc2e5522e658885fffa7b"
    end
  end

  private
  def change_table(&block)
    super :webmasters_cms_pages, &block
  end
end
