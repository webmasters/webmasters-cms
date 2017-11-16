class CreateForeignKeyWithNewNameToWebmastersCmsPagesForRails51 < ActiveRecord::Migration[5.1]
  def up
    change_table do |t|
      t.foreign_key :webmasters_cms_pages, :column => "parent_id",
        :name => "fk_rails_b6d179f800504cc308d42c55d972ae950343e73e91c53a9928"
    end
  end

  def down
    change_table do |t|
      t.remove_foreign_key :column => "parent_id",
        :name => "fk_rails_b6d179f800504cc308d42c55d972ae950343e73e91c53a9928"
    end
  end

  private
  def change_table(&block)
    super :webmasters_cms_pages, &block
  end
end
