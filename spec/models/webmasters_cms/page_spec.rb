require 'spec_helper'

module WebmastersCms
  describe Page do

    let (:page) { FactoryGirl.create(:webmasters_cms_page) }
    let (:page2) { FactoryGirl.create(:webmasters_cms_page) }
    let (:child_page1) { FactoryGirl.create(:webmasters_cms_page, parent: page) }
    let (:child_page2) { FactoryGirl.create(:webmasters_cms_page, parent: page) }


    describe ".without_page(not_persisted_page)" do
      it "returns a collection of all available pages" do
        expect(Page.without_page(Page.new)).to include(page)
        expect(Page.without_page(Page.new)).to include(page2)
      end
    end

    describe ".without_page(persisted_page)" do
      it "returns a collection without the persisted page" do
        expect(Page.without_page(page2)).to include(page)
        expect(Page.without_page(page2)).to_not include(page2)
      end
    end

    describe ".update_tree(valid_hash)" do
      it "updates the parent_id (value) of the page_id (key)" do
        Page.update_tree({child_page1.id => page.id})

        child_page1.reload

        expect(child_page1.parent_id).to eq(page.id)
      end

      it "translates parent_id 'null' to parent_id nil" do
        Page.update_tree({child_page1.id => 'null'})

        child_page1.reload

        expect(child_page1.parent_id).to be_nil
      end

      it "moves a child_page1 to second place and child_page2 to first" do
        child_page1
        child_page2
        child_page3 = FactoryGirl.create(:webmasters_cms_page, parent: page)
        params = {}
        params[page.id.to_s] = 'null'
        params[child_page2.id.to_s] = page.id.to_s
        params[child_page1.id.to_s] = page.id.to_s
        params[child_page3.id.to_s] = page.id.to_s
        page
        expect(page.children(true)).to eq([child_page1, child_page2, child_page3])

        Page.update_tree(params)

        expect(page.children(true)).to eq([child_page2, child_page1, child_page3])
      end

      it "saves a new branch when a child_page is placed on a child_page" do
        child_page1
        child_page2
        params = {}
        params[page.id.to_s] = 'null'
        params[child_page1.id.to_s] = page.id.to_s
        params[child_page2.id.to_s] = child_page1.id.to_s

        expect(page.children(true)).to eq([child_page1, child_page2])

        Page.update_tree(params)

        expect(page.children(true)).to eq([child_page1])
        expect(child_page1.children(true)).to eq([child_page2])
      end

      it "closes a branch when the last child_page is removed" do
        child_page1
        child_page2 = FactoryGirl.create(:webmasters_cms_page, parent: child_page1)
        params = {}
        params[page.id.to_s] = 'null'
        params[child_page1.id.to_s] = page.id.to_s
        params[child_page2.id.to_s] = page.id.to_s

        expect(page.children(true)).to eq([child_page1])
        expect(child_page1.children(true)).to eq([child_page2])
        Page.update_tree(params)
        expect(page.children(true)).to eq([child_page1, child_page2])
        expect(child_page1.children(true)).to be_empty
      end

      it "does not place a root page as a child" do
        page
        page2
        params = {}
        params[page.id.to_s] = 'null'
        params[page2.id.to_s] = page.id.to_s

        expect(page2.parent_id).to be_nil

        Page.update_tree(params)

        expect(page2.parent_id).to be_nil
      end

    end

    describe ".update_tree(invalid_hash)" do
      it "does nothing" do
        Page.update_tree({page.id => 'wrong'})

        page.reload

        expect(page.parent_id).to be_nil
      end
    end

    describe ".find_or_initialize_by_language(lang)" do
      it "finds a translation in the database" do
        page_translation = page.translations.first

        expect(page.translations.find_or_initialize_by_language(page_translation.language)).to eq(page_translation) 
      end

      it "finds a translation in the params" do
        page = build(:webmasters_cms_page)
        page_translation = build(:webmasters_cms_page_translation, page: page)
        page.translations = [page_translation]
        expect(page.translations.find_or_initialize_by_language(page.translations.first.language)).to eq(page_translation)
      end

      it "creates a new translation" do
        new_translation = page.translations.find_or_initialize_by_language('en')
        expect(new_translation).to be_instance_of(PageTranslation)
        expect(new_translation.language).to eq('en')
        expect(new_translation.page_id).to eq(page.id)
      end
    end
  end
end
