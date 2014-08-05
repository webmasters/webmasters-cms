class CreateConstraintForeignKeyPageId < ActiveRecord::Migration
  def change
    add_index :webmasters_cms_page_translations, :page_id

    reversible do |dir|
      dir.up do
        execute "ALTER TABLE webmasters_cms_page_translations
            ADD CONSTRAINT fk_page_page_translations
            FOREIGN KEY (page_id)
            REFERENCES webmasters_cms_pages(id)"
      end
      dir.down do
        execute "ALTER TABLE webmasters_cms_page_translations
            DROP FOREIGN KEY fk_page_page_translations"
      end
    end
  end
end
