require 'spec_helper'

module WebmastersCms
  describe Page::Version do
    before :each do
      @cms_page = FactoryGirl.create(:webmasters_cms_page)
    end

    it "gets created on Page attribute change" do
      expect{
        @cms_page.update_attributes(name: "New Name")
      }.to change(Page::Version, :count).by(1)
    end

    it "gets not saved on Page tree changes" do
      neighbor_page = FactoryGirl.create(:webmasters_cms_page)
      expect{
        @cms_page.move_to_child_of(neighbor_page)
      }.to_not change(Page::Version, :count)
    end
  end
end