module WebmastersCms
  class Page < ActiveRecord::Base
    has_many :translations, class_name: "PageTranslation", inverse_of: :page, dependent: :destroy
    accepts_nested_attributes_for :translations, allow_destroy: true, reject_if: proc { |attr| attr.all? {|k,v| v.blank? || ['language'].include?(k)}}

    after_update :delete_when_without_translations

    acts_as_nested_set

    def delete_node_keep_children
      if self.child?
        self.move_children_to_immediate_parent
      else
        self.move_children_to_root
      end
      self.reload
      self.destroy
    end

    def move_children_to_immediate_parent
      immediate_children = self.children
      immediate_parent = self.parent
      immediate_children.each do |child|
        child.move_to_child_of(immediate_parent)
        immediate_parent.reload
      end
    end

    def move_children_to_root
      immediate_children = self.children
      immediate_children.each do |child|
        child.move_to_root
        child.reload
      end
    end

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

    protected
      def delete_when_without_translations
        if self.translations.empty?
          delete_node_keep_children
        end
      end
  end
end
