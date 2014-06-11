module WebmastersCms
  class Page < ActiveRecord::Base
    validates :name, :local_path, uniqueness: true

    validates :name, :title, :local_path, :meta_description,
      length: { maximum: 255 },
      presence: true

    validates :body,
      length: { maximum: 65535 },
      presence: true

    validates :local_path, format: { with: /\A[a-zA-Z0-9\-\_]+\z/ }
  end
end
