module WebmastersCms
  class Page < ActiveRecord::Base
    self.primary_key = :id
    validates_uniqueness_of :name
    validates_uniqueness_of :local_path

    validates :name, :title, :local_path, :meta_description,
      length: { maximum: 255 },
      presence: true

    validates :body,
      length: { maximum: 65535 },
      presence: true

    validates_format_of :local_path,
      with: /[a-zA-Z0-9\-\_]/
  end
end
