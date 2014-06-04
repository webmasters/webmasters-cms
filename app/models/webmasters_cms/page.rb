module WebmastersCms
  class Page < ActiveRecord::Base
    validates_uniqueness_of :name
    validates_uniqueness_of :local_path

    validates :name, :title, :local_path, :meta_description,
      length: { maximum: 255 },
      presence: true

    validates :body,
      length: { maximum: 65535 },
      presence: true

    validates_format_of :local_path,
      with: /\A[a-zA-Z0-9\-\_]+\z/
  end
end
