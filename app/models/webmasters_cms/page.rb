module WebmastersCms
  class Page < ActiveRecord::Base
    has_many :translations,
      class_name: "PageTranslation",
      inverse_of: :page, dependent: :destroy do

      def find_or_initialize_by_language(language)
        detect do |translation|
          translation.language == language
        end || find_or_initialize_by(language: language)
      end
    end

    accepts_nested_attributes_for :translations,
      allow_destroy: true,
      reject_if: proc { |attr| attr.all? { |k,v| v.blank? || ['language'].include?(k) } }

    acts_as_nested_set

    validates :count_of_translations, numericality: { only_integer: true, greater_than: 0 }

    def self.create_dummy_page_for_language(language)
      page_params = {name: "Index", local_path: "", meta_description: "Change me", body: "Change me", title: "First Page", language: language, soft_deleted: false}
      if roots.empty?
        create!(translations_attributes: [page_params])
      elsif not root.translations.find_by(language: language)
        root.translations.create!(page_params)
      end
    end

    def count_of_translations
      translations.size
    end

    def active_translations
      languages = ActiveLanguage.all.collect(&:code)
      translations.where(language: languages).order('language')
    end

    def not_deleted_translations
      translations.where(soft_deleted: false)
    end

    def displayname
      translations.first.name
    end

    def translated_local_paths
      translations.inject({}) do |sum, translation|
        sum["#{translation.language}_local_path"] = translation.local_path
        sum
      end
    end

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
  end
end
