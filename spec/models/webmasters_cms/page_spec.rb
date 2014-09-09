require 'spec_helper'

module WebmastersCms
  describe Page do

    let (:cms_page) { FactoryGirl.create(:webmasters_cms_page) }
    let (:cms_page2) { FactoryGirl.create(:webmasters_cms_page) }
    let (:child_page1) { FactoryGirl.create(:webmasters_cms_page, parent: cms_page) }
    let (:child_page2) { FactoryGirl.create(:webmasters_cms_page, parent: cms_page) }

    describe ".without_page(not_persisted_page)" do
      it "returns a collection of all available pages" do
        expect(Page.without_page(Page.new)).to include(cms_page)
        expect(Page.without_page(Page.new)).to include(cms_page2)
      end
    end

    describe ".without_page(persisted_page)" do
      it "returns a collection without the persisted page" do
        expect(Page.without_page(cms_page2)).to include(cms_page)
        expect(Page.without_page(cms_page2)).to_not include(cms_page2)
      end
    end

    describe ".update_tree(valid_hash)" do
      it "updates the parent_id (value) of the page_id (key)" do
        Page.update_tree({child_page1.id => cms_page.id})

        child_page1.reload

        expect(child_page1.parent_id).to eq(cms_page.id)
      end

      it "translates parent_id 'null' to parent_id nil" do
        Page.update_tree({child_page1.id => 'null'})

        child_page1.reload

        expect(child_page1.parent_id).to be_nil
      end

      it "moves a child_page1 to second place and child_page2 to first" do
        child_page1
        child_page2
        child_page3 = FactoryGirl.create(:webmasters_cms_page, parent: cms_page)
        params = {}
        params[cms_page.id.to_s] = 'null'
        params[child_page2.id.to_s] = cms_page.id.to_s
        params[child_page1.id.to_s] = cms_page.id.to_s
        params[child_page3.id.to_s] = cms_page.id.to_s
        cms_page
        expect(cms_page.children(true)).to eq([child_page1, child_page2, child_page3])

        Page.update_tree(params)

        expect(cms_page.children(true)).to eq([child_page2, child_page1, child_page3])
      end

      it "saves a new branch when a child_page is placed on a child_page" do
        child_page1
        child_page2
        params = {}
        params[cms_page.id.to_s] = 'null'
        params[child_page1.id.to_s] = cms_page.id.to_s
        params[child_page2.id.to_s] = child_page1.id.to_s

        expect(cms_page.children(true)).to eq([child_page1, child_page2])

        Page.update_tree(params)

        expect(cms_page.children(true)).to eq([child_page1])
        expect(child_page1.children(true)).to eq([child_page2])
      end

      it "closes a branch when the last child_page is removed" do
        child_page1
        child_page2 = FactoryGirl.create(:webmasters_cms_page, parent: child_page1)
        params = {}
        params[cms_page.id.to_s] = 'null'
        params[child_page1.id.to_s] = cms_page.id.to_s
        params[child_page2.id.to_s] = cms_page.id.to_s

        expect(cms_page.children(true)).to eq([child_page1])
        expect(child_page1.children(true)).to eq([child_page2])
        Page.update_tree(params)
        expect(cms_page.children(true)).to eq([child_page1, child_page2])
        expect(child_page1.children(true)).to be_empty
      end

      it "does not place a root page as a child" do
        cms_page
        cms_page2
        params = {}
        params[cms_page.id.to_s] = 'null'
        params[cms_page2.id.to_s] = cms_page.id.to_s

        expect(cms_page2.parent_id).to be_nil

        Page.update_tree(params)

        expect(cms_page2.parent_id).to be_nil
      end

    end

    describe ".update_tree(invalid_hash)" do
      it "does nothing" do
        Page.update_tree({cms_page.id => 'wrong'})

        cms_page.reload

        expect(cms_page.parent_id).to be_nil
      end
    end
  end
end
