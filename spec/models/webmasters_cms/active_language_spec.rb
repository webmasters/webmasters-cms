require 'spec_helper'

module WebmastersCms
  describe ActiveLanguage do
    describe "after_save :create_index_page_if_first_page" do
      it "creates a new Page" do
        expect do
          ActiveLanguage.create(code: 'kl')
        end.to change(Page, :count).by(1)
      end

      it "creates a new PageTranslation" do
        expect do
          ActiveLanguage.create(code: 'kl')
        end.to change(PageTranslation, :count).by(1)
      end
    end
  end
end