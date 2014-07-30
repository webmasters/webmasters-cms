module WebmastersCms
  class PageTranslation < ActiveRecord::Base
    acts_as_versioned table_name: "webmasters_cms_page_versions",
      if_changed: [:name, :local_path, :title, :meta_description, :body]

    validates :name, :local_path, uniqueness: true

    validates :name, :title, :local_path, :meta_description,
      length: { maximum: 255 },
      presence: true

    validates :body,
      length: { maximum: 65535 },
      presence: true

    validates :local_path, format: { with: /\A[a-zA-Z0-9\-\_]+\z/ }

    validates :language, presence: true

    def current_version
      versions.where(:version => version).first
    end
  end
end
