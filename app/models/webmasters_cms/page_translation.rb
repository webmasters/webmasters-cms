module WebmastersCms
  class PageTranslation < ActiveRecord::Base
    belongs_to :page, inverse_of: :translations
    validates :page, presence: true

    acts_as_versioned table_name: "webmasters_cms_page_translation_versions",
      if_changed: [:name, :local_path, :title, :meta_description, :body, :language],
      non_versioned_columns: [:page_id]

    validates :name, uniqueness: {:scope => :page_id}
    validates :local_path, uniqueness: {:scope => :page_id}

    validates :name, :title, :local_path, :meta_description,
      length: { maximum: 255 },
      presence: true

    validates :body,
      length: { maximum: 65535 },
      presence: true

    validates :local_path, format: { with: /\A[a-zA-Z0-9\-\_]+\z/ }

    validates :language, presence: true, active_languages: true, uniqueness: {scope: :page_id}

    def current_version
      versions.where(version: version).first
    end
  end
end
