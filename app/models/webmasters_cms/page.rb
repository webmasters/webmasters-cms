class WebmastersCms::Page < WebmastersCms::ApplicationRecord
  has_many :translations,
    class_name: "PageTranslation",
    inverse_of: :page, dependent: :destroy do

    def find_or_initialize_by_language(language)
      detect do |translation|
        translation.language == language
      end || find_or_initialize_by(language: language)
    end
  end

  BLANK_ATTRIBUTES_FOR_TRANSLATIONS = [:title, :meta_description, :name, :local_path, :body]
  accepts_nested_attributes_for :translations,
    allow_destroy: true,
    reject_if: lambda {|attr| BLANK_ATTRIBUTES_FOR_TRANSLATIONS.all? {|name| attr[name].blank? } }

  acts_as_nested_set

  validates :count_of_translations, numericality: { only_integer: true, greater_than: 0 }
  
  validates :host_index, numericality: { only_integer: true, greater_than_or_equal_to: 0}
  validates :host_index, numericality: { equal_to: lambda {|r| r.parent.host_index }, if: :parent_id }
  validates :host_index, uniqueness: { scope: [:parent_id, :host_index], :unless => :parent_id}

  before_validation :set_host_index_from_parent

  def count_of_translations
    translations.size
  end

  def active_translations
    languages = WebmastersCms::ActiveLanguage.all.collect(&:code)
    translations.where(language: languages, soft_deleted: false).order('language')
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
    if child?
      move_children_to_immediate_parent
    else
      move_children_to_root
    end
    reload
    destroy
  end

  def move_children_to_immediate_parent
    immediate_children = children
    immediate_parent = parent
    immediate_children.each do |child|
      child.move_to_child_of(immediate_parent)
      immediate_parent.reload
    end
  end

  def move_children_to_root
    immediate_children = children
    immediate_children.each do |child|
      child.move_to_root
      child.reload
    end
  end

  def self.first_child_of_page(id)
    find(id).children.first
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
        attributes = {parent_id: new_parent_id}
        attributes[:host_index] = maximum(:host_index).next if !new_parent_id && child.parent_id.present?
        child.update_attributes! attributes
      end

      page_ids_with_parent_ids.each do |page_id, new_parent_id|
        child = find(page_id)
        child.move_to_right_of(child.siblings.last) if child.siblings.exists?
      end
    end

    true
  rescue => e
#    p e.inspect if Rails.env.test?
    Rails.logger.error e.inspect
    false
  end

  def self.create_dummy_page_for_language(language)
    page_params = {name: "Index", local_path: "", 
      meta_description: "Change me", body: "Change me", 
      title: "First Page", language: language, soft_deleted: false}
    if roots.empty?
      create!(translations_attributes: [page_params])
    elsif not root.translations.find_by(language: language)
      root.translations.create!(page_params)
    end
  end

  private
  def set_host_index_from_parent
    self.host_index = if parent_id_changed? && parent
      parent.host_index 
    elsif new_record? && !parent
      if host_index_db = self.class.maximum(:host_index)
        host_index_db.next
      else
        self.class.column_for_attribute(:host_index).default
      end
    else
      host_index
    end
    true
  end
end
