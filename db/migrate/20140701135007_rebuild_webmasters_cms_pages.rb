class RebuildWebmastersCmsPages < ActiveRecord::Migration
  def up
    WebmastersCms::Page.transaction do
      WebmastersCms::Page.reset_column_information
      WebmastersCms::Page.rebuild!
    end
  end
end
