class CreateWebmastersCmsActiveLanguages < ActiveRecord::Migration
  def change
    create_table :webmasters_cms_active_languages do |t|
      t.string :name, null: false
      t.string :native_name, null: false
      t.string :code, null: false
      t.index :code, unique: true
    end
  end
end
