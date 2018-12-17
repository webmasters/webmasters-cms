class CreateWebmastersCmsFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :webmasters_cms_files do |t|
      t.attachment :file
      t.bigint :uploaded_by_id, :unsigned => true
      t.timestamps

      t.index :uploaded_by_id

      if table_name = WebmastersCms.uploaded_by_table_name
        t.foreign_key table_name, :column => :uploaded_by_id
      end
    end
  end
end
