class WebmastersCms::ActiveLanguagesValidator < ActiveModel::EachValidator

  def validate_each(record, attr_name, value)
    unless ActiveLanguage.active?(value)
      record.errors.add(attr_name, :not_active, options)
    end
  end
end
