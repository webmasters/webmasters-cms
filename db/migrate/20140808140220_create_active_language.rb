class CreateActiveLanguage < ActiveRecord::Migration
  class WebmastersCms::ActiveLanguage < ActiveRecord::Base
  end

  def up
    unless WebmastersCms::ActiveLanguage.where(code: 'en').exists?
      WebmastersCms::ActiveLanguage.create! code: 'en'
    end
  end
end
