class ChangeForeignKeysToBigintForWebmastersCmsPages < ActiveRecord::Migration[5.1]
  def up
    change_table do |t|
      t.change :parent_id, :bigint, :null => true, :unsigned => true, :default => nil
    end
  end

  def down
    change_table do |t|
      t.change :parent_id, :integer, :null => true, :unsigned => true, :default => nil
    end
  end

  private
  def change_table(&block)
    super :webmasters_cms_pages, &block
  end
end
