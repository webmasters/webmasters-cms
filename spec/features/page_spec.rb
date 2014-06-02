require 'spec_helper'

module WebmastersCms
  describe "A user" do
    it "creates a new page" do
      visit 'webmasters_cms/pages/new'
      fill_in 'Name', :with => "CapyTest"
      fill_in 'Local path', :with => "CapyTest"
      fill_in 'Title', :with => "CapyTest"
      fill_in 'Meta description', :with => "CapyTest"
      fill_in 'Body', :with => "CapyTest"
      click_button 'Create Page'
      expect(page).to have_content 'Page successfully created'
    end
  end
end