require 'spec_helper'

module WebmastersCms
  describe "Pages" do
    describe "Manage pages" do
      it "creates a new page and displays it with a success notice" do
        visit new_admin_page_path

        expect{
          fill_in 'Name', :with => "Name"
          fill_in 'Local path', :with => "Local_path"
          fill_in 'Title', :with => "Title"
          fill_in 'Meta description', :with => "Meta Description"
          fill_in 'Body', :with => "Body"
          click_button 'Create Page'
        }.to change(Page,:count).by(1)

        within '.success' do
          expect(page).to have_content 'Page successfully created'
        end

        expect(page).to have_css 'meta[name="description"][content="Meta Description"]', :visible => false
        expect(page).to have_title "Title"
        expect(page).to have_content "Name"
        expect(page).to have_content "Body"
      end

      it "shows an error when created with invalid attributes" do
        visit new_admin_page_path

        fill_in "Title", with: ""
        fill_in "Name", with: ""
        fill_in "Local path", with: ""
        fill_in "Meta description", with: ""
        fill_in "Body", with: ""
        click_button "Create Page"

        expect(page).to have_css "#error_explanation"
        expect(page).to have_selector('.field_with_errors #page_title')
        expect(page).to have_selector('.field_with_errors #page_local_path')
        expect(page).to have_selector('.field_with_errors #page_name')
        expect(page).to have_selector('.field_with_errors #page_meta_description')
        expect(page).to have_selector('.field_with_errors #page_body')
      end

      it "edits a page successfully and displays a success notice" do
        cms_page = FactoryGirl.create(:webmasters_cms_page)
        visit edit_admin_page_path(cms_page)

        fill_in "Title", with: "Updated Title"
        fill_in "Name", with: "Updated Name"
        fill_in "Local path", with: "Updated_Local_Path"
        fill_in "Meta description", with: "Updated Meta Description"
        fill_in "Body", with: "Updated Body"
        click_button "Update Page"

        expect(current_path).to eq(admin_page_path(cms_page))
        expect(page).to have_css 'meta[name="description"][content="Updated Meta Description"]', :visible => false
        expect(page).to have_title "Updated Title"
        expect(page).to have_content "Updated Name"
        expect(page).to have_content "Updated Body"

        within ".success" do
          expect(page).to have_content "Page successfully updated"
        end
      end

      it "shows an error when edited with invalid attributes" do
        cms_page = FactoryGirl.create(:webmasters_cms_page)

        visit edit_admin_page_path(cms_page)

        fill_in "Title", with: ""
        fill_in "Name", with: ""
        fill_in "Local path", with: ",.IN&V@L1D.,"
        fill_in "Meta description", with: ""
        fill_in "Body", with: ""
        click_button "Update Page"

        expect(page).to have_css "#error_explanation"
        expect(page).to have_selector('.field_with_errors #page_title')
        expect(page).to have_selector('.field_with_errors #page_local_path')
        expect(page).to have_selector('.field_with_errors #page_name')
        expect(page).to have_selector('.field_with_errors #page_meta_description')
        expect(page).to have_selector('.field_with_errors #page_body')
      end

      it "deletes a page and displays a success notice", js: true do
        DatabaseCleaner.clean
        cms_page = FactoryGirl.create(:webmasters_cms_page, name: "DeleteMe", title: "DeleteMe")

        visit admin_pages_path

        expect{
          within "ul li" do
            click_link "Delete"
          end
          page.driver.browser.switch_to.alert.accept

          expect(current_path).to eq(admin_pages_path)
        }.to change(Page,:count).by(-1)

        within '.success' do
          expect(page).to have_content "Page successfully deleted"
        end

        expect(page).to_not have_content "DeleteMe"
      end
    end
  end
end