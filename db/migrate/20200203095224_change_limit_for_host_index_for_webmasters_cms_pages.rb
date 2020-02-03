class ChangeLimitForHostIndexForWebmastersCmsPages < ActiveRecord::Migration[6.0]

  def up
    change_table do |t|
      t.change :host_index, :integer, :limit => 1,
        :unsigned => true, :default => 0, :null => false
    end
  end

  def down
    change_table do |t|
      t.change :host_index, :integer, :limit => 4,
        :unsigned => true, :default => 0, :null => false
    end
  end

  private
  def change_table(&block)
    super :webmasters_cms_pages, &block
  end
end