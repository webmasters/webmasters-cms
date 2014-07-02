class AddVersioningToPage < ActiveRecord::Migration
  def change
    WebmastersCms::Page.create_versioned_table
  end
end
