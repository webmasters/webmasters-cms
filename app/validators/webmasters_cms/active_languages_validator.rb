module WebmastersCms
  class ActiveLanguagesValidator < ActiveModel::Validator

    def validate(record)
      active_languages = ActiveLanguage.all
      
      if active_languages.find_by(code: record.language).nil?
        record.errors[:base] << "Language is not active"
      end
    end

  end
end