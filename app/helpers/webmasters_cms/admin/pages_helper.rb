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

        content_tag :ul, lines.join("\n").html_safe
      end

      def create_list_item(page)
        list_item = []
        list_item << link_to(page.name, admin_page_path(page))
        list_item << h("(#{t('.title')}: #{page.title})")
        list_item << render(partial: 'actions', locals: {page: page})
        list_item.join(" ").html_safe
      end

      def nested_set_for_select
        nested_set_options(collection, resource) {|i| "#{'-' * i.level} #{i.name}" }
      end
    end
  end
end
