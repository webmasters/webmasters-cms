class AddNullConstraintsToAllColumns < ActiveRecord::Migration[4.2]
  def change
    change_column_null :webmasters_cms_pages, :name, false
    change_column_null :webmasters_cms_pages, :local_path, false
    change_column_null :webmasters_cms_pages, :title, false
    change_column_null :webmasters_cms_pages, :meta_description, false
    change_column_null :webmasters_cms_pages, :body, false
  end
end
