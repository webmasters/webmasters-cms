module WebmastersCms
  class Page < ActiveRecord::Base
    acts_as_nested_set
    acts_as_versioned table_name: "webmasters_cms_page_versions",
      if_changed: [:name, :local_path, :title, :meta_description, :body]
    self.non_versioned_columns += ['rgt', 'lft', 'parent_id']

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
          child = find(page_id)
          if new_parent_id == "null"
            child.update_attributes!(:parent_id => nil)
          else
            child.update_attributes!(:parent_id => new_parent_id)
          end
        end

        page_ids_with_parent_ids.each do |page_id, new_parent_id|
          child = find(page_id)
          child.move_right if child.right_sibling
        end
      end

      true
    rescue => e
      # p e.inspect if Rails.env.test?
      Rails.logger.error e.inspect
      false
    end

    # def self.update_tree(array)
    #   transaction do
    #     array.each do |object|
    #       if object[:item_id] != 'null'
    #         cms_page = find(object[:item_id])
    #         cms_page.update_attributes!(:lft => object[:left], :parent_id => object[:parent_id], :rgt => object[:right])
    #       end
    #     end
    #   end
    #   true
    # rescue => e
    #   # p e.inspect if Rails.env.test?
    #   Rails.logger.error e.inspect
    #   false
    # end

    def current_version
      versions.where(:version => version).first
    end
  end
end
