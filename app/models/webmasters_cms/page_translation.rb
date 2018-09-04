class WebmastersCms::PageTranslation < WebmastersCms::ApplicationRecord
  belongs_to :page, inverse_of: :translations
  validates :page, presence: true

  acts_as_versioned table_name: "webmasters_cms_page_translation_versions",
    if_changed: [:name, :local_path, :title, :meta_description, :body, :language],
    non_versioned_columns: [:page_id, :soft_deleted, :show_in_navigation, 
      :redirect_to_child, :redirect_to, :menu_icon_css_class]

  validates :name, :local_path, uniqueness: {scope: :language}

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
end
