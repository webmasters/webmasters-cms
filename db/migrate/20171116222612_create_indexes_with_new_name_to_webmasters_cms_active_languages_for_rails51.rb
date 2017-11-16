class CreateIndexesWithNewNameToWebmastersCmsActiveLanguagesForRails51 < ActiveRecord::Migration[5.1]
  def up
    change_table do |t|
      t.index [:code],
        :unique => true,
        :name => "index_rails_a4fcee5453f5b38d3d44a0e625fefa0d2fb4cc53263b2acdee"
    end
  end

  def down
    change_table do |t|
      t.remove_index :name => "index_rails_a4fcee5453f5b38d3d44a0e625fefa0d2fb4cc53263b2acdee"
    end
  end

  private
  def change_table(&block)
    super :webmasters_cms_active_languages, &block
  end
end
