class CreateWebmastersCmsActiveLanguages < ActiveRecord::Migration[4.2]
  def change
    create_table :webmasters_cms_active_languages, :unsigned => false do |t|
      t.string :code, null: false
      t.index :code, unique: true
    end
  end
end
