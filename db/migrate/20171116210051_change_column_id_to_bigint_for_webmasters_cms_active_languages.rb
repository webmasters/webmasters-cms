class ChangeColumnIdToBigintForWebmastersCmsActiveLanguages < ActiveRecord::Migration[5.1]
  def up
    change_table do |t|
      t.change :id, :bigint, :unsigned => true
    end
  end

  def down
    change_table do |t|
      t.change :id, :integer, :unsigned => true
    end
  end

  private
  def change_table(&block)
    super :webmasters_cms_active_languages, &block
  end
end
