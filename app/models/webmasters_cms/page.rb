module WebmastersCms
  class Page < ActiveRecord::Base
    has_many :translations, class_name: "PageTranslation", inverse_of: :page
    accepts_nested_attributes_for :translations, allow_destroy: true, reject_if: proc { |attr| attr.all? {|k,v| v.blank? || ['language'].include?(k)}}

    acts_as_nested_set

    def self.without_page(page)
      if page.persisted?
        where.not(id: page.id)
      else
        where({})
      end
    end

    def self.update_tree(page_ids_with_parent_ids)
      transaction do
        page_ids_with_parent_ids.each do |page_id, new_parent_id|
          child = find(page_id)
          new_parent_id = nil if new_parent_id == "null"
          child.update_attributes!(:parent_id => new_parent_id)
        end

        page_ids_with_parent_ids.each do |page_id, new_parent_id|
          child = find(page_id)
          child.move_to_right_of(child.siblings.last) if child.siblings.exists?
        end
      end

      true
    rescue => e
      # p e.inspect if Rails.env.test?
      Rails.logger.error e.inspect
      false
    end
  end
end
