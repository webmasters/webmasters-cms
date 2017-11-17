class ChangeColumnIdToBigintForWebmastersCmsPageTranslations < ActiveRecord::Migration[5.1]
  def up
    change_table do |t|
      t.change :id, :bigint, :unsigned => true, :auto_increment => true
    end
  end

  def down
    change_table do |t|
      t.change :id, :integer, :unsigned => true, :auto_increment => true
    end
  end

  private
  def change_table(&block)
    super :webmasters_cms_page_translations, &block
  end
end
