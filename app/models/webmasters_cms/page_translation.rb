class WebmastersCms::PageTranslation < WebmastersCms::ApplicationRecord
  belongs_to :page, inverse_of: :translations
  validates :page, presence: true

  acts_as_versioned table_name: "webmasters_cms_page_translation_versions",
    if_changed: [:name, :local_path, :title, :meta_description, :body, :language],
    non_versioned_columns: [:page_id, :soft_deleted, :show_in_navigation, 
      :redirect_to_child, :redirect_to, :menu_icon_css_class]

  validate :validates_uniqueness_of_name,
    :validates_uniqueness_of_local_path, :if => :page

  validates :local_path, :redirect_to, length: { maximum: 255 }

  validates :name, :title,
    length: { maximum: 255 },
    presence: true

  validates :body, :meta_description,
    length: { maximum: 65535 },
    presence: true

  validates :local_path, format: { with: /\A[a-zA-Z0-9\-\_\/\.]+\z/, allow_blank: true }

  validates :language, presence: true, 'webmasters_cms/active_languages': true,
    uniqueness: {scope: :page_id, case_sensitive: true }

  validates :soft_deleted, :show_in_navigation, :redirect_to_child, inclusion: [true, false]

  def self.internal_paths
    @internal_paths ||= Rails.application.routes.routes.collect do |r|
      r.path.spec.to_s.split('(').first
    end.select do |r|
      !r.include?(':') && !r.include?('admin') && !r.include?('*') && r != '/'
    end.sort.uniq
  end

  def self.internal_path?(path)
    internal_paths.include? path
  end

  def current_version
    versions.where(version: version).first
  end

  def deleted?
    soft_deleted
  end

  def internal_path?
    self.class.internal_path? "/#{local_path}"
  end

  private
  def validates_uniqueness_of_name
    relation = self.class
    relation = relation.joins(:page).where WebmastersCms::Page.table_name => {host_index: page.host_index, :parent_id => page.parent_id}
    relation = relation.where :language => language
    relation = relation.where.not :id => id if persisted?
    
    if relation.where(:name => name).exists?
      errors.add :name, :taken, :value => name
    end
  end
  
  def validates_uniqueness_of_local_path
    relation = self.class
    relation = relation.joins(:page).where WebmastersCms::Page.table_name => {host_index: page.host_index}
    relation = relation.where :language => language
    relation = relation.where.not :id => id if persisted?
    
    if relation.where(:local_path => local_path).exists?
      errors.add :local_path, :taken, :value => local_path
    end
  end
end
