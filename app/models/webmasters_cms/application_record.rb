class WebmastersCms::ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  self.table_name = nil # fix for table_name detection
  self.belongs_to_required_by_default = false if self.respond_to?(:belongs_to_required_by_default) # for Rails 5.2

  def self.table_exists?
    super
  rescue ActiveRecord::NoDatabaseError
    false
  end
end
