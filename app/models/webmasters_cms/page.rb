module WebmastersCms
  class Page < ActiveRecord::Base
    acts_as_nested_set

    validates :name, :local_path, uniqueness: true

    validates :name, :title, :local_path, :meta_description,
      length: { maximum: 255 },
      presence: true

    validates :body,
      length: { maximum: 65535 },
      presence: true

    validates :local_path, format: { with: /\A[a-zA-Z0-9\-\_]+\z/ }

    def self.without_page(page)
      if page.persisted?
        where.not(id: page.id)
      else
        where({})
      end
    end

    def self.updateParent_Ids(pages)
      pages.each do |page, parent| {
        child = Page.find(page)
        child.parent_id = parent
      }
    end
  end
end
