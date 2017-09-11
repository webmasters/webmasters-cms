require 'spec_helper'

module WebmastersCms
  describe Page do

    let (:page1) { FactoryGirl.create(:webmasters_cms_page) }
    let (:child_page1) { FactoryGirl.create(:webmasters_cms_page, parent: page1) }
    let (:child_page2) { FactoryGirl.create(:webmasters_cms_page, parent: page1) }
    let (:page2) { FactoryGirl.create(:webmasters_cms_page) }

    describe ".create_dummy_page_for_language(language)" do
      before(:each) do
        language = build(:webmasters_cms_active_language, code: 'en')
        allow(language).to receive(:create_index_page_if_first_page).and_return(true)
        language.save!
      end

      context "no root exists" do

        it "creates a new Page when there is no root" do
          expect do
            Page.create_dummy_page_for_language('en')
          end.to change(Page, :count).by(1)
        end

        it "creates a new PageTranslation when there is no root" do
          expect do
            Page.create_dummy_page_for_language('en')
          end.to change(PageTranslation, :count).by(1)
        end

        it "creates a new PageTranslation with the given language" do
          expect(Page.create_dummy_page_for_language('en').translations.first.language).to eq('en')
        end
      end

      context "there is a root" do
        before(:each) do
          built_page = build(:webmasters_cms_page_without_translation)
          built_page.translations << build(:webmasters_cms_page_translation, language: 'de', page: built_page)
          built_page.save!
        end

        it "creates no new Page" do
          expect do
            Page.create_dummy_page_for_language('en')
          end.to_not change(Page, :count)
        end

        it "creates a new PageTranslation" do
          expect do
            Page.create_dummy_page_for_language('en')
          end.to change(PageTranslation, :count).by(1)
        end

        it "creates a new PageTranslation with the given language" do
          expect(Page.create_dummy_page_for_language('en').language).to eq('en')
        end
      end
    end

    describe ".without_page(not_persisted_page)" do
      it "returns a collection of all available pages" do
        expect(Page.without_page(Page.new)).to include(page1)
        expect(Page.without_page(Page.new)).to include(page2)
      end
    end

    describe ".without_page(persisted_page)" do
      it "returns a collection without the persisted page" do
        expect(Page.without_page(page2)).to include(page1)
        expect(Page.without_page(page2)).to_not include(page2)
      end
    end

    describe ".update_tree(valid_hash)" do
      it "updates the parent_id (value) of the page_id (key)" do
        Page.update_tree({child_page1.id => page1.id})

        child_page1.reload

        expect(child_page1.parent_id).to eq(page1.id)
      end

      it "translates parent_id 'null' to parent_id nil" do
        Page.update_tree({child_page1.id => 'null'})

        child_page1.reload

        expect(child_page1.parent_id).to be_nil
      end

      it "moves a child_page1 to second place and child_page2 to first" do
        child_page1
        child_page2
        child_page3 = FactoryGirl.create(:webmasters_cms_page, parent: page1)
        params = {}
        params[page1.id.to_s] = 'null'
        params[child_page2.id.to_s] = page1.id.to_s
        params[child_page1.id.to_s] = page1.id.to_s
        params[child_page3.id.to_s] = page1.id.to_s
        page1
        expect(page1.children.reload).to eq([child_page1, child_page2, child_page3])

        Page.update_tree(params)

        expect(page1.children.reload).to eq([child_page2, child_page1, child_page3])
      end

      it "saves a new branch when a child_page is placed on a child_page" do
        child_page1
        child_page2
        params = {}
        params[page1.id.to_s] = 'null'
        params[child_page1.id.to_s] = page1.id.to_s
        params[child_page2.id.to_s] = child_page1.id.to_s

        expect(page1.children.reload).to eq([child_page1, child_page2])

        Page.update_tree(params)

        expect(page1.children.reload).to eq([child_page1])
        expect(child_page1.children.reload).to eq([child_page2])
      end

      it "closes a branch when the last child_page is removed" do
        child_page1
        child_page2 = FactoryGirl.create(:webmasters_cms_page, parent: child_page1)
        params = {}
        params[page1.id.to_s] = 'null'
        params[child_page1.id.to_s] = page1.id.to_s
        params[child_page2.id.to_s] = page1.id.to_s

        expect(page1.children.reload).to eq([child_page1])
        expect(child_page1.children.reload).to eq([child_page2])
        Page.update_tree(params)
        expect(page1.children.reload).to eq([child_page1, child_page2])
        expect(child_page1.children.reload).to be_empty
      end

      it "does not place a root page as a child" do
        page1
        page2
        params = {}
        params[page1.id.to_s] = 'null'
        params[page2.id.to_s] = page1.id.to_s

        expect(page2.parent_id).to be_nil

        Page.update_tree(params)

        expect(page2.parent_id).to be_nil
      end

    end

    describe ".update_tree(invalid_hash)" do
      it "does nothing" do
        Page.update_tree({page1.id => 'wrong'})

        page1.reload

        expect(page1.parent_id).to be_nil
      end
    end

    describe ".find_or_initialize_by_language(lang)" do
      it "finds a translation in the database" do
        page_translation = page1.translations.first

        expect(page1.translations.find_or_initialize_by_language(page_translation.language)).to eq(page_translation)
      end

      it "finds a translation in the params" do
        built_page = build(:webmasters_cms_page)
        page_translation = build(:webmasters_cms_page_translation, page: built_page)
        built_page.translations = [page_translation]
        expect(built_page.translations.find_or_initialize_by_language(built_page.translations.first.language)).to eq(page_translation)
      end

      it "creates a new translation" do
        new_translation = page1.translations.find_or_initialize_by_language('en')
        expect(new_translation).to be_instance_of(PageTranslation)
        expect(new_translation.language).to eq('en')
        expect(new_translation.page_id).to eq(page1.id)
      end
    end

    describe ".count_of_translations" do
      it "returns an integer" do
        expect(page1.count_of_translations).to be_kind_of(Integer)
      end

      it "returns the amount of translations of a page" do
        FactoryGirl.create(:webmasters_cms_page_translation, page: page1)
        expect(page1.count_of_translations).to eq(2)
      end
    end

    describe ".displayname" do
      it "returns a string" do
        expect(page1.displayname).to be_kind_of(String)
      end

      it "returns the name of the first translation of the page" do
        expect(page1.displayname).to eq(page1.translations.first.name)
      end
    end

    describe ".not_deleted_translations" do
      it "returns an array of PageTranslations" do
        expect(page1.not_deleted_translations).to be_kind_of(ActiveRecord::AssociationRelation)
      end

      it "does not contain PageTranslations with soft_deleted set true" do
        deleted_translation = create(:webmasters_cms_page_translation, :deleted, page: page1)
        expect(page1.not_deleted_translations).to_not include(deleted_translation)
      end
    end
  end
end
