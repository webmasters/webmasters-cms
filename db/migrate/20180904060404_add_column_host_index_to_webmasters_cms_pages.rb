class AddColumnHostIndexToWebmastersCmsPages < ActiveRecord::Migration[5.1]
  def change
    change_table :webmasters_cms_pages do |t|
      t.integer :host_index, null: false, unsigned: true, default: 0
    end
  end
end
