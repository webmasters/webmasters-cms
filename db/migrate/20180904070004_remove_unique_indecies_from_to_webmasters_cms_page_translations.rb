class RemoveUniqueIndeciesFromToWebmastersCmsPageTranslations < ActiveRecord::Migration[5.1]
  def up
    change_table do |t|

      t.remove_index columns: [:language, :local_path],
        name: 'index_rails_f244e57bf38531e0618a8daca55e425e02f7a9a50f6fcdecda'

      t.remove_index columns: [:language, :name],
        name: 'index_rails_6bcc7f17f93f94d9d9ac700cdd964bb76271f117af256a24ba'
    end
  end

  def down
    change_table do |t|
      t.index [:language, :local_path], unique: true,
        name: 'index_rails_f244e57bf38531e0618a8daca55e425e02f7a9a50f6fcdecda'

      t.index [:language, :name], unique: true, 
        name: 'index_rails_6bcc7f17f93f94d9d9ac700cdd964bb76271f117af256a24ba'
    end
  end

  private
  def change_table(&block)
    super :webmasters_cms_page_translations, &block
  end
end
