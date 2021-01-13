class CreateActiveLanguage < ActiveRecord::Migration[4.2]
  class WebmastersCmsActiveLanguage < ActiveRecord::Base
  end

  def up
    klass = WebmastersCmsActiveLanguage
    klass.reset_column_information
    klass.transaction do
      klass.create! code: 'en' unless klass.where(code: 'en').exists?
    end
  end
end
