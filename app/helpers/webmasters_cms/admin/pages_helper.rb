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
            list_item << link_to("(#{page_translation.language}) #{page_translation.name}", edit_admin_page_path(page, language: page_translation.language))
          end
        end
        if list_item.empty?
          list_item << "Disabled Articles"
        end
        list_item << render('actions', page: page)
        list_item.join(" ").html_safe
      end

      def nested_set_for_select
        nested_set_options(collection, resource) {|i| "#{'-' * i.level} #{i.translations.find_by(page_id: i.id).name}" }
      end
    end
  end
end