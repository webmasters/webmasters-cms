module WebmastersCms
  module Admin
    module PagesHelper
      def list_collection_ancestry(pages = collection.roots)
        lines = pages.collect do |page|
          line_content = []
          line_content << content_tag(:span, create_list_item_page(page))

          unless page.children.empty?
            line_content << list_collection_ancestry(page.children)
          end

          content_tag :li, line_content.join("\n").html_safe, id: "page_#{page.id}"
        end

        content_tag :ul, lines.join("\n").html_safe, class: "pages_tree"
      end

      def create_list_item_page(page)
        page_translations = page.translations.sort do |a,b| a.language <=> b.language end
        list_item = []
        page_translations.each do |page_translation|
          if ActiveLanguage.find_by(code: page_translation.language) && !page_translation.deleted?
            list_item << "(#{page_translation.language}) #{page_translation.name} "
            list_item << link_to(t(".edit"), edit_admin_page_path(page, language: page_translation.language))
            list_item << link_to_preview(page_translation)
            list_item << link_to(t(".soft_delete"), soft_delete_admin_page_translation_path(page_id: page_translation.page_id, id: page_translation.id),
              method: :patch,
              data: { confirm: "#{t('.alert_soft_delete')}" }, name: "delete_#{page_translation.id}")
            list_item << "|" unless page_translation == page_translations.last
          end
        end
        if list_item.empty?
          list_item << t(".disabled_articles")
          list_item << link_to(t('.new_translation'), edit_admin_page_path(page))
          list_item << link_to(t('.delete_node'), admin_page_path(id: page.id),
              method: :delete,
              data: { confirm: "#{t('.alert_sure')}" })
        end
        list_item.join(" ").html_safe
      end

      def link_to_preview(page_translation)
        link_to t(".show"), preview_url_for(page_translation), target: "_blank"
      end

      def preview_url_for(page_translation)
        "/#{page_translation.language}/#{page_translation.local_path}"
      end

      def nested_set_for_select
        nested_set_options(collection, resource, :translated_local_paths) do |page|
          "#{'-' * page.level} #{page.displayname}"
        end
      end

      def nested_set_options(class_or_item, mover=nil, data_attribute_method=nil)
        if class_or_item.is_a? Array
          items = class_or_item.reject { |e| !e.root? }
        else
          class_or_item = class_or_item.roots if class_or_item.respond_to?(:scope)
          items = Array(class_or_item)
        end
        result = []
        items.each do |root|
          result += root.class.associate_parents(root.self_and_descendants).map do |i|
            if mover.nil? || mover.new_record? || mover.move_possible?(i)
              options = if data_attribute_method
                {data: i.send(data_attribute_method)}
              else
                {}
              end
              [yield(i), i.primary_id, options]
            end
          end.compact
        end
        result
      end

      OPTIONS_FOR_PAGE_TRANSLATION_BODY={size: "60x20", 
        data: {ckeditor_options: {}, locator: 'cke_body'} 
      }
      def options_for_page_translation_body(translation, ckeditor_options={}, additional_options={})
        options = OPTIONS_FOR_PAGE_TRANSLATION_BODY.merge(additional_options)
        options[:data][:ckeditor_options] = ckeditor_options.to_json
        options
      end
    end
  end
end
