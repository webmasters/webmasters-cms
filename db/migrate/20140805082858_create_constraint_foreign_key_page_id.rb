class CreateConstraintForeignKeyPageId < ActiveRecord::Migration
  def self.up
    add_foreign_key :webmasters_cms_page_translations, :pages,
      :column => :page_id, :name => 'fk_page_page_translations'
  end

  def self.down
    remove_foreign_key :webmasters_cms_page_translations, :column => :page_id,
      :name => 'fk_page_page_translations'
  end 
end
