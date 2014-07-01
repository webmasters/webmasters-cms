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

    def self.update_parents(page_ids_with_parent_ids)
      transaction do
        page_ids_with_parent_ids.each do |page_id, new_parent_id|
          child = Page.find(page_id)
          if new_parent_id == "null"
            child.update_attributes!(:parent_id => nil)
          else
            child.update_attributes!(:parent_id => new_parent_id)
          end
        end
      end
      
      true
    rescue => e
      # p e.inspect if Rails.env.test?
      Rails.logger.error e.inspect
      false
    end
  end
end
