class CreateActiveLanguage < ActiveRecord::Migration[4.2]
  class WebmastersCms::ActiveLanguage < ActiveRecord::Base
  end

  def up
    unless WebmastersCms::ActiveLanguage.where(code: 'en').exists?
      WebmastersCms::ActiveLanguage.create! code: 'en'
    end
  end
end
