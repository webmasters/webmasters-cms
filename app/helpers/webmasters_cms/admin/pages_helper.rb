module WebmastersCms
  module Admin
    module PagesHelper
      def list_collection_ancestry(pages = collection.roots)
        lines = pages.collect do |page|
          line_content = []
          line_content << content_tag(:span, create_list_item(page))

          unless page.children.empty?
            line_content << list_collection_ancestry(page.children)
          end

          content_tag :li, line_content.join("\n").html_safe, id: "page_#{page.id}"
        end

        content_tag :ul, lines.join("\n").html_safe, class: "pages_tree"
      end

      def create_list_item(page)
        page_translations = page.translations.sort do |a,b| a.language <=> b.language end
        list_item = []
        page_translations.each do |page_translation|
          if ActiveLanguage.find_by(code: page_translation.language)
            list_item << "(#{page_translation.language}) #{page_translation.name} "
            list_item << link_to("Edit", edit_admin_page_path(page, language: page_translation.language))
            list_item << link_to("Show", "/#{page_translation.language}/#{page_translation.local_path}")
            list_item << link_to("Delete", admin_page_translation_path(page_id: page_translation.page_id, id: page_translation.id),
              method: :delete,
              data: { confirm: 'Are you sure?' })
            list_item << "|" unless page_translation == page_translations.last
          end
        end
        if list_item.empty?
          list_item << "Disabled Articles"
        end
        list_item.join(" ").html_safe
      end

      def nested_set_for_select
        nested_set_options(collection, resource) do |page| 
          "#{'-' * page.level} #{page.displayname}"
        end
      end
    end
  end
end