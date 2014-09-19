module WebmastersCms
  module Admin
    module FormHelper
      def errors_for(field, form_object)
        if form_object.errors.messages[field]
          form_object.errors.messages[field].map do |error|
            "<span class=\"field_error\">#{field.to_s.humanize} #{error}</span><br />"
          end.join("\n").html_safe
        end
      end
    end
  end
end