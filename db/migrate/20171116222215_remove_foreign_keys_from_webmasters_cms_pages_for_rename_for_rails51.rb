class RemoveForeignKeysFromWebmastersCmsPagesForRenameForRails51 < ActiveRecord::Migration[5.1]
  def up
    change_table do |t|
      t.remove_foreign_key :column => "parent_id",
        :name => "webmasters_cms_pages_parent_id_fk"
    end
  end

  def down
    change_table do |t|
      t.foreign_key :webmasters_cms_pages, :column => "parent_id",
        :name => "webmasters_cms_pages_parent_id_fk"
    end
  end

  private
  def change_table(&block)
    super :webmasters_cms_pages, &block
  end
end
