require 'spec_helper'

module WebmastersCms
  describe "Pages" do
    describe "Manage pages" do
      it "creates a new page and displays it with a success notice" do
        visit new_page_path

        expect{
          fill_in 'Name', :with => "Name"
          fill_in 'Local path', :with => "Local_path"
          fill_in 'Title', :with => "Title"
          fill_in 'Meta description', :with => "Meta Description"
          fill_in 'Body', :with => "Body"
          click_button 'Create Page'
        }.to change(Page,:count).by(1)

        within '.success' do
          page.should have_content 'Page successfully created'
        end

        page.should have_css 'meta[name="description"][content="Meta Description"]', :visible => false
        page.should have_title "Title"
        page.should have_content "Name"
        page.should have_content "Body"
      end

      it "shows an error when created with invalid attributes" do
        visit new_page_path

        fill_in "Title", with: ""
        fill_in "Name", with: ""
        fill_in "Local path", with: ""
        fill_in "Meta description", with: ""
        fill_in "Body", with: ""
        click_button "Create Page"

        page.should have_css "#error_explanation"
        expect(page).to have_selector('.field_with_errors #page_title')
        expect(page).to have_selector('.field_with_errors #page_local_path')
        expect(page).to have_selector('.field_with_errors #page_name')
        expect(page).to have_selector('.field_with_errors #page_meta_description')
        expect(page).to have_selector('.field_with_errors #page_body')
      end

      it "edits a page successfully and displays a success notice" do
        cms_page = FactoryGirl.create(:webmasters_cms_page)
        visit edit_page_path(cms_page)

        fill_in "Title", with: "Updated Title"
        fill_in "Name", with: "Updated Name"
        fill_in "Local path", with: "Updated_Local_Path"
        fill_in "Meta description", with: "Updated Meta Description"
        fill_in "Body", with: "Updated Body"
        click_button "Update Page"

        current_path.should eq(page_path("Updated_Local_Path"))
        page.should have_css 'meta[name="description"][content="Updated Meta Description"]', :visible => false
        page.should have_title "Updated Title"
        page.should have_content "Updated Name"
        page.should have_content "Updated Body"

        within ".success" do
          page.should have_content "Page successfully updated"
        end
      end

      it "shows an error when edited with invalid attributes" do
        cms_page = FactoryGirl.create(:webmasters_cms_page)

        visit edit_page_path(cms_page)

        fill_in "Title", with: ""
        fill_in "Name", with: ""
        fill_in "Local path", with: ",.IN&V@L1D.,"
        fill_in "Meta description", with: ""
        fill_in "Body", with: ""
        click_button "Update Page"

        page.should have_css "#error_explanation"
        expect(page).to have_selector('.field_with_errors #page_title')
        expect(page).to have_selector('.field_with_errors #page_local_path')
        expect(page).to have_selector('.field_with_errors #page_name')
        expect(page).to have_selector('.field_with_errors #page_meta_description')
        expect(page).to have_selector('.field_with_errors #page_body')
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

        within '.success' do
          page.should have_content "Page successfully deleted"
        end

        page.should_not have_content "DeleteMe"
      end
    end
  end
end