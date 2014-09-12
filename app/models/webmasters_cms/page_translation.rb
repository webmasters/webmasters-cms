module WebmastersCms
  class PageTranslation < ActiveRecord::Base
    belongs_to :page, inverse_of: :translations
    validates :page, presence: true

    acts_as_versioned table_name: "webmasters_cms_page_translation_versions",
      if_changed: [:name, :local_path, :title, :meta_description, :body, :language],
      non_versioned_columns: [:page_id]

    validates :name, :local_path, uniqueness: {:scope => [:page_id, :language]}

    validates :local_path, length: { maximum: 255 }

    validates :name, :title, :meta_description,
      length: { maximum: 255 },
      presence: true

    validates :body,
      length: { maximum: 65535 },
      presence: true

    validates :local_path, format: { with: /\A[a-zA-Z0-9\-\_]+\z/, allow_blank: true }

    validates :language, presence: true, active_languages: true, uniqueness: {scope: :page_id}

    def current_version
      versions.where(version: version).first
    end
  end
end
