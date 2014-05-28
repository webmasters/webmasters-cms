module WebmastersCms
  class Page < ActiveRecord::Base
    validates_uniqueness_of :name
    validates_uniqueness_of :local_path

    validates :name, :title, :local_path, :meta_description,
      length: {
        maximum: 255,
        too_long: "%{count} characters is the maximum allowed!"
      },
      presence: true

    validates :body,
      length: { maximum: 65535 },
      presence: true

    validates_format_of :local_path,
      with: /[a-zA-Z0-9\-\_]/,
      message: "Only alphanumeric letters, hyphens and underscore are allowed!"
  end
end
