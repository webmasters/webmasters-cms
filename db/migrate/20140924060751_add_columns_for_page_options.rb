class AddColumnsForPageOptions < ActiveRecord::Migration[4.2]
  def change
    transaction do
      add_column :webmasters_cms_page_translations, :redirect_to_child, :boolean, default: false
      add_column :webmasters_cms_page_translations, :show_in_navigation, :boolean, default: true
      add_column :webmasters_cms_page_translations, :redirect_to, :string, null: true
    end
  end
end
