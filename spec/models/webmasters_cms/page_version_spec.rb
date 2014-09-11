require 'spec_helper'

module WebmastersCms
  describe PageTranslation::Version do
    before :each do
      page = FactoryGirl.create(:webmasters_cms_page)
    end

    it "gets created on Page attribute change" do
      expect{
        page.update_attributes!(name: "New Name")
      }.to change(PageTranslation::Version, :count).by(1)
    end

    it "gets not saved on Page tree changes" do
      neighbor_page = FactoryGirl.create(:webmasters_cms_page_translation, page: page)
      expect{
        page.move_to_child_of(neighbor_page)
      }.to_not change(PageTranslation::Version, :count)
    end
  end
end