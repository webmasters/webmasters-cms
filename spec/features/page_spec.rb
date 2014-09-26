require 'spec_helper'

module WebmastersCms
  describe "Pages" do
    describe "Manage pages" do

      let (:cms_page) { create(:webmasters_cms_page) }
      let (:page_translation) { cms_page.translations.first }

      before(:each) do
        create(:webmasters_cms_active_language)
      end

      it "creates a new page and displays it with a success notice", js: true do
        visit new_admin_page_path

        find(:css, 'input[type="radio"][id="code_en"]').click

        expect{
          fill_in 'Name', with: "Name"
          fill_in 'Local path', with: "Local_path"
          fill_in 'Title', with: "Title"
          fill_in 'Meta description', with: "Meta Description"
          fill_in_ckeditor 'cke_body', with: "Body"
          click_button 'Create Page'
        }.to change(Page, :count).by(1)

        within '.notice' do
          expect(page).to have_content 'Page successfully created!'
        end

        expect(page).to have_content "Name"
      end

      it "shows an error when created with invalid attributes", js: true do
        visit new_admin_page_path

        find(:css, 'input[type="radio"][id="code_en"]').click

        fill_in "Title", with: "Title"
        fill_in "Name", with: ""
        fill_in "Local path", with: "*@%#{}"
        fill_in "Meta description", with: ""
        fill_in_ckeditor 'cke_body', with: ""
        click_button "Create Page"

        expect(page).to have_selector('.field_with_errors')
        expect(page).to have_selector('.field_error')
        expect(page).to have_content("Name can't be blank")
        expect(page).to have_content("Meta description can't be blank")
        expect(page).to have_content("Body can't be blank")
        expect(page).to have_content("Local path can only consist of alphanumeric letters, hyphens and underscores")
      end

      it "edits a page successfully and displays a success notice", js: true do
        DatabaseCleaner.clean
        visit edit_admin_page_path(cms_page, language: page_translation.language)

        fill_in "Title", with: "Updated Title"
        fill_in "Name", with: "Updated Name"
        fill_in "Local path", with: "Updated_Local_Path"
        fill_in "Meta description", with: "Updated Meta Description"
        fill_in_ckeditor "cke_body", with: "Updated Body"
        click_button "Update Page"

        within ".success" do
          expect(page).to have_content "Page successfully updated"
        end
        expect(page).to have_content "Updated Name"
      end

      it "shows an error when edited with invalid attributes", js: true do
        visit edit_admin_page_path(cms_page, language: page_translation.language)

        fill_in "Title", with: ""
        fill_in "Name", with: ""
        fill_in "Local path", with: ",.IN&V@L1D.,"
        fill_in "Meta description", with: ""
        # fill_in_ckeditor "cke_body", with: nil
        click_button "Update Page"

        expect(page).to have_selector('.field_with_errors')
        expect(page).to have_selector('.field_error')
        expect(page).to have_content("Title can't be blank")
        expect(page).to have_content("Name can't be blank")
        expect(page).to have_content("Meta description can't be blank")
        # expect(page).to have_content("Body can't be blank")
        expect(page).to have_content("Local path can only consist of alphanumeric letters, hyphens and underscores")
      end

      it "deletes a page and displays a success notice", js: true do
        DatabaseCleaner.clean
        cms_page_delete = FactoryGirl.create(:webmasters_cms_page)
        page_translation_delete = cms_page_delete.translations.first

        visit admin_pages_path

        expect{
          find(:css, "[name='delete_#{page_translation_delete.id}']").click
          page.driver.browser.switch_to.alert.accept

          expect(current_path).to eq(admin_pages_path)
        }.to change(PageTranslation, :count).by(0)

        within '.notice' do
          expect(page).to have_content "Successfully deleted!"
        end
        expect(page).to_not have_content(page_translation_delete.name)
      end

      it "nestes a child page under a root page" do
        child_page = FactoryGirl.create(:webmasters_cms_page).move_to_child_of(cms_page)
        child_translation = child_page.translations.first

        visit admin_pages_path

        within "div > ul > #page_#{page_translation.id} > span" do
          expect(page).to have_content page_translation.name
        end

        within "#page_#{page_translation.id} > ul > #page_#{child_translation.id} > span" do
          expect(page).to have_content child_translation.name
        end
      end

      it "nestes a child page under a child page" do
        child_page1 = FactoryGirl.create(:webmasters_cms_page).move_to_child_of(cms_page)
        child_translation1 = child_page1.translations.first
        child_page2 = FactoryGirl.create(:webmasters_cms_page).move_to_child_of(child_page1)
        child_translation2 = child_page2.translations.first

        visit admin_pages_path

        within "div > ul > #page_#{page_translation.id} > ul > #page_#{child_translation1.id} > ul > #page_#{child_translation2.id} > span" do
          expect(page).to have_content child_translation2.name
        end
      end

      it "previews a page from the edit page", js: true do
        visit edit_admin_page_path(cms_page, language: page_translation.language)

        click_button "Preview"

        page.driver.browser.switch_to.window page.driver.browser.window_handles.last do
          expect(page).to have_content page_translation.name
          expect(page).to have_content page_translation.body
        end
      end

      it "previews a page from the create new page", js: true do
        visit new_admin_page_path

        find(:css, 'input[type="radio"][id^="code_"]').click

        fill_in 'Name', with: "Name"
        fill_in 'Local path', with: "Local_path"
        fill_in 'Title', with: "Title"
        fill_in 'Meta description', with: "Meta Description"
        fill_in_ckeditor 'cke_body', with: "Body"

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

    def wait_until(default_wait_time=Capybara.default_wait_time, &block)
      start = Time.now
      end_time = start + default_wait_time.seconds

      while true
        timeout = Time.now > end_time
        begin
          result = yield
          break if result || timeout
        rescue Exception => e
          raise e if timeout
        end
        sleep 0.3
      end
    end

    def fill_in_ckeditor(locator, opts)
      content = opts.fetch(:with)
      ckeditor_instance = "CKEDITOR.instances[jQuery('[data-locator=\"#{locator}\"]').attr('id')]"

      wait_until do
        result = page.evaluate_script <<-SCRIPT
          CKEDITOR && (#{ckeditor_instance}) && (#{ckeditor_instance}.ui != undefined) && typeof(#{ckeditor_instance}.getData()) == 'string'
        SCRIPT
        expect result
        result 
      end

      wait_until do
        page.execute_script <<-SCRIPT
          #{ckeditor_instance}.insertText("#{content}");
        SCRIPT

        page.evaluate_script("#{ckeditor_instance}.getData()").include?(content)
      end
    end 
  end
end