class ChangeForeignKeysToBigintForWebmastersCmsPageTranslationVersions < ActiveRecord::Migration[5.1]
  def up
    change_table do |t|
      t.change :page_translation_id, :bigint, :null => true, :unsigned => true, :default => nil
    end
  end

  def down
    change_table do |t|
      t.change :page_translation_id, :integer, :null => true, :unsigned => true, :default => nil
    end
  end

  private
  def change_table(&block)
    super :webmasters_cms_page_translation_versions, &block
  end
end
