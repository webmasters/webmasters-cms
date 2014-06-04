require 'spec_helper'

module WebmastersCms
  describe "Pages" do
    describe "Manage pages" do
      it "creates a new page and displays it with a success notice" do
        visit new_page_path

        expect{
          fill_in 'Name', :with => "CapyTest Name"
          fill_in 'Local path', :with => "CapyTest_Local_Path"
          fill_in 'Title', :with => "CapyTest Title"
          fill_in 'Meta description', :with => "CapyTest Meta Description"
          fill_in 'Body', :with => "CapyTest Body"
          click_button 'Create Page'
        }.to change(Page,:count).by(1)

        within 'div.success' do
          page.should have_content 'Page successfully created'
        end

        page.should have_content "CapyTest Name"
        page.should have_content "CapyTest Body"
        page.should have_title "CapyTest Title"
        page.should have_css 'meta[name="description"][content="CapyTest Meta Description"]', :visible => false
      end

      it "deletes a page and displays a success notice", js: true do
        DatabaseCleaner.clean
        cms_page = FactoryGirl.create(:webmasters_cms_page, name: "DeleteMe", title: "DeleteMe")

        visit pages_path

        expect{
          within "ul li" do
            click_link "Destroy"
          end
          page.driver.browser.switch_to.alert.accept
          expect(current_path).to eq(pages_path)
        }.to change(Page,:count).by(-1)

        within 'div.success' do
          page.should have_content "Page successfully deleted"
        end

        page.should_not have_content "DeleteMe"
      end
    end
  end
end