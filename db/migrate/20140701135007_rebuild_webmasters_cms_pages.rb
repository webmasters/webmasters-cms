class RebuildWebmastersCmsPages < ActiveRecord::Migration
  def up
    WebmastersCms::Page.transaction do
      WebmastersCms::Page.rebuild!
    end
  end
end
