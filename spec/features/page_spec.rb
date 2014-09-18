require 'spec_helper'

module WebmastersCms
  describe "Pages" do
    describe "Manage pages" do

      let (:cms_page) { create(:webmasters_cms_page) }
      let (:page_translation) { page.translations.first }

      before(:each) do
        create(:webmasters_cms_active_language)
      end

      it "creates a new page and displays it with a success notice", js: true do
        visit new_admin_page_path

        find(:css, 'input[type="radio"][id^="code_"]').click

        expect{
          fill_in 'Name', :with => "Name"
          fill_in 'Local path', :with => "Local_path"
          fill_in 'Title', :with => "Title"
          fill_in 'Meta description', :with => "Meta Description"
          fill_in_ckeditor 'Body', :with => "Body"
          click_button 'Create Page'
        }.to change(Page,:count).by(1)

        within '.success' do
          expect(page).to have_content 'Page successfully created'
        end

        expect(page).to have_content "Title"
        expect(page).to have_content "Name"
      end

      it "shows an error when created with invalid attributes" do
        visit new_admin_page_path

        find(:css, 'input[type="radio"][id^="code_"]').click

        fill_in "Title", with: ""
        fill_in "Name", with: ""
        fill_in "Local path", with: ""
        fill_in "Meta description", with: ""
        fill_in_ckeditor "Body", with: ""
        click_button "Create Page"

        expect(page).to have_css "#error_explanation"
        expect(page).to have_selector('.field_with_errors #page_title')
        expect(page).to have_selector('.field_with_errors #page_local_path')
        expect(page).to have_selector('.field_with_errors #page_name')
        expect(page).to have_selector('.field_with_errors #page_meta_description')
        expect(page).to have_selector('.field_with_errors #page_body')
      end

      it "edits a page successfully and displays a success notice" do
        visit edit_admin_page_path(cms_page)

        find(:css, 'input[type="radio"][id^="code_"]').click

        fill_in "Title", with: "Updated Title"
        fill_in "Name", with: "Updated Name"
        fill_in "Local path", with: "Updated_Local_Path"
        fill_in "Meta description", with: "Updated Meta Description"
        fill_in_ckeditor "Body", with: "Updated Body"
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
        visit edit_admin_page_path(cms_page)

        find(:css, 'input[type="radio"][id^="code_"]').click

        fill_in "Title", with: ""
        fill_in "Name", with: ""
        fill_in "Local path", with: ",.IN&V@L1D.,"
        fill_in "Meta description", with: ""
        fill_in_ckeditor "Body", with: ""
        click_button "Update Page"

        expect(page).to have_css "#error_explanation"
        expect(page).to have_selector('.field_with_errors #page_title')
        expect(page).to have_selector('.field_with_errors #page_local_path')
        expect(page).to have_selector('.field_with_errors #page_name')
        expect(page).to have_selector('.field_with_errors #page_meta_description')
        expect(page).to have_selector('.field_with_errors #page_body')
      end

      it "shows a page" do
        visit admin_page_path(PageTranslation.last)

        expect(page).to have_title "#{page_translation.title}"
        expect(page).to have_css "meta[name='description'][content='#{page_translation.meta_description}']", visible: false
        expect(page).to have_content "#{page_translation.name}"
        expect(page).to have_content "#{page_translation.body}"
      end

      it "deletes a page and displays a success notice" do
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

      it "nestes a child page under a root page" do
        child_page = FactoryGirl.create(:webmasters_cms_page).move_to_child_of(cms_page)

        visit admin_pages_path

        within "body > ul > li > span" do
          expect(page).to have_content cms_page.name
        end

        within "body > ul > li > ul > li > span" do
          expect(page).to have_content child_page.name
        end
      end

      it "nestes a child page under a child page" do
        child_page1 = FactoryGirl.create(:webmasters_cms_page).move_to_child_of(cms_page)
        child_page2 = FactoryGirl.create(:webmasters_cms_page).move_to_child_of(child_page1)
        page_translation2 = child_page2.translations.first

        visit admin_pages_path

        within "body > ul > li > ul > li > ul > li > span" do
          expect(page).to have_content page_translation2.name
        end
      end

      it "nestes a child page under a root page in parent selection" 

      it "previews a page from the edit page", js: true do
        visit edit_admin_page_path(cms_page)

        find(:css, 'input[type="radio"][id^="code_"]').click

        click_button "Preview"

        page.driver.browser.switch_to.window page.driver.browser.window_handles.last do
          expect(page).to have_content page_translation.name
          expect(page).to have_content page_translation.body
        end
      end

      it "previews a page from the create new page", js: true do
        visit new_admin_page_path

        find(:css, 'input[type="radio"][id^="code_"]').click

        fill_in 'Name', :with => "Name"
        fill_in 'Local path', :with => "Local_path"
        fill_in 'Title', :with => "Title"
        fill_in 'Meta description', :with => "Meta Description"
        fill_in_ckeditor 'Body', :with => "Body"

        click_button "Preview"

        page.driver.browser.switch_to.window page.driver.browser.window_handles.last do
          expect(page).to have_content "Name"
          expect(page).to have_content "Body"
        end
      end

      it "adds cssclass ok to title length counter with good length", js: true do
        visit new_admin_page_path

        find(:css, 'input[type="radio"][id^="code_"]').click

        fill_in 'Title', :with => "A"*20

        expect(page).to have_selector "span.titleLength.ok"
        expect(page).to have_content "20 / 55"
      end

      it "adds cssclass ok to meta desc length counter with good length", js: true do
        visit new_admin_page_path

        find(:css, 'input[type="radio"][id^="code_"]').click

        fill_in 'Meta description', :with => "A"*55

        expect(page).to have_css "span.metaDescLength.ok"
        expect(page).to have_content "55 / 155"
      end

      it "adds cssclass warning to title length counter with long length", js: true do
        visit new_admin_page_path

        find(:css, 'input[type="radio"][id^="code_"]').click

        fill_in 'Title', :with => "A"*120

        expect(page).to have_css "span.titleLength.warning"
        expect(page).to have_content "120 / 55"
      end

      it "adds cssclass warning to meta desc length counter with long length", js: true do
        visit new_admin_page_path

        find(:css, 'input[type="radio"][id^="code_"]').click

        fill_in 'Meta description', :with => "A"*170

        expect(page).to have_css "span.metaDescLength.warning"
        expect(page).to have_content "170 / 155"
      end

    end
  end
end