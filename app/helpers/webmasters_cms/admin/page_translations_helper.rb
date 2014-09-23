module WebmastersCms
  module Admin
    module PageTranslationsHelper
      def list_deleted_translations
        lines = collection_of_deleted_translations.collect do |translation|
          line_content = []
          line_content << content_tag(:span, create_list_item_translation(translation))
          content_tag :li, line_content.join("\n").html_safe, id: "translation_#{translation.id}"
        end
        
        content_tag :ul, lines.join("\n").html_safe
      end

      def create_list_item_translation(translation)
        list_item = []
        list_item << "(#{translation.language}) #{translation.name} "
        list_item << link_to(t(".show"), "/#{translation.language}/#{translation.local_path}", target: "_blank")
        list_item << link_to(t(".undelete"), undelete_admin_page_translation_path(page_id: translation.page_id, id: translation.id),
          method: :patch,
          data: { confirm: "#{t('.info_undelete')}" })
        list_item << link_to(t(".delete"), admin_page_translation_path(page_id: translation.page_id, id: translation.id),
          method: :delete,
          data: { confirm: "#{t('.alert_delete')}" })
        list_item.join(" ").html_safe
      end
    end
  end
end