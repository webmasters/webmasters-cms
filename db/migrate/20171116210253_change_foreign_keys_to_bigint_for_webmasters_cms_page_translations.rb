class ChangeForeignKeysToBigintForWebmastersCmsPageTranslations < ActiveRecord::Migration[5.1]
  def up
    change_table do |t|
      t.change :page_id, :bigint, :null => false, :unsigned => true, :default => "0"
    end
  end

  def down
    change_table do |t|
      t.change :page_id, :integer, :null => false, :unsigned => true, :default => "0"
    end
  end

  private
  def change_table(&block)
    super :webmasters_cms_page_translations, &block
  end
end
