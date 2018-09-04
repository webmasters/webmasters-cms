class WebmastersCms::PageTranslation < WebmastersCms::ApplicationRecord
  belongs_to :page, inverse_of: :translations
  validates :page, presence: true

  acts_as_versioned table_name: "webmasters_cms_page_translation_versions",
    if_changed: [:name, :local_path, :title, :meta_description, :body, :language],
    non_versioned_columns: [:page_id, :soft_deleted, :show_in_navigation, 
      :redirect_to_child, :redirect_to, :menu_icon_css_class]

  validate :validates_uniqueness_of_name_and_local_path, :if => :page

  validates :local_path, :redirect_to, length: { maximum: 255 }

  validates :name, :title, :meta_description,
    length: { maximum: 255 },
    presence: true

  validates :body,
    length: { maximum: 65535 },
    presence: true

  validates :local_path, format: { with: /\A[a-zA-Z0-9\-\_\/\.]+\z/, allow_blank: true }

  validates :language, presence: true, active_languages: true, uniqueness: {scope: :page_id }

  validates :soft_deleted, :show_in_navigation, :redirect_to_child, inclusion: [true, false]

  def current_version
    versions.where(version: version).first
  end

  def deleted?
    soft_deleted
  end

  private
  def validates_uniqueness_of_name_and_local_path
    relation = self.class
    relation = relation.joins(:page).where WebmastersCms::Page.table_name => {host_index: page.host_index }
    relation = relation.where.not :id => id if persisted?
    
    if relation.where(:local_path => local_path).exists?
      errors.add :local_path, :taken, :value => local_path
    end
    
    if relation.where(:name => name).exists?
      errors.add :name, :taken, :value => name
    end
  end
end
