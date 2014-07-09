require 'spec_helper'

module WebmastersCms
  describe Page do

    let (:cms_page) { FactoryGirl.create(:webmasters_cms_page) }
    let (:child_page1) { FactoryGirl.create(:webmasters_cms_page, parent: cms_page) }

    it "has a valid factory" do
      expect(cms_page).to be_valid
    end

    describe "#name" do
      it "is invalid without an unique name" do
        page2 = FactoryGirl.build(:webmasters_cms_page, name: cms_page.name)
        expect(page2).to_not be_valid
      end

      it "is invalid without a name" do
        expect(FactoryGirl.build(:webmasters_cms_page, name: nil)).to_not be_valid
      end

      it "is invalid with a too long name" do
        expect(FactoryGirl.build(:webmasters_cms_page, name: "A"*256)).to_not be_valid
      end

      it "is valid with a long name with multibyte characters" do
        expect(FactoryGirl.build(:webmasters_cms_page, name: "A"*253 + "€€")).to be_valid
      end
    end

    describe "#local_path" do
      it "is valid with an alphanumeric local_path" do
        expect(FactoryGirl.build(:webmasters_cms_page, local_path: "deoxyribonucleinacid")).to be_valid
      end

      it "is valid with an underscore and hyphen in local_path" do
        expect(FactoryGirl.build(:webmasters_cms_page, local_path: "underscore_and-hyphen")).to be_valid
      end

      it "is invalid without an unique local_path" do
        page2 = FactoryGirl.build(:webmasters_cms_page, local_path: cms_page.local_path)
        expect(page2).to_not be_valid
      end

      it "is invalid with a too long local_path" do
        expect(FactoryGirl.build(:webmasters_cms_page, local_path: "A"*256)).to_not be_valid
      end

      it "is invalid with special characters in the local_path" do
        expect(FactoryGirl.build(:webmasters_cms_page, local_path: ",.\"/?\\|[+={]';!@#$%^&*()'}")).to_not be_valid
      end
    end

    describe "#title" do
      it "is invalid without a title" do
        expect(FactoryGirl.build(:webmasters_cms_page, title: nil)).to_not be_valid
      end

      it "is invalid with a too long title" do
        expect(FactoryGirl.build(:webmasters_cms_page, title: "A"*256)).to_not be_valid
      end
    end

    describe "#meta_description" do
      it "is invalid without a meta_description" do
        expect(FactoryGirl.build(:webmasters_cms_page, meta_description: nil)).to_not be_valid
      end

      it "is invalid with a too long meta_description" do
        expect(FactoryGirl.build(:webmasters_cms_page, meta_description: "A"*256)).to_not be_valid
      end
    end

    describe "#body" do
      it "is invalid without a body" do
        expect(FactoryGirl.build(:webmasters_cms_page, body: nil)).to_not be_valid
      end

      it "is invalid with a too long body" do
        expect(FactoryGirl.build(:webmasters_cms_page, body: "A"*65536)).to_not be_valid
      end
    end

    describe ".without_page(not_persisted_page)" do
      it "returns a collection of all available pages" do
        cms_page2 = FactoryGirl.create(:webmasters_cms_page)

        expect(Page.without_page(Page.new)).to include(cms_page)
        expect(Page.without_page(Page.new)).to include(cms_page2)
      end
    end

    describe ".without_page(persisted_page)" do
      it "returns a collection without the persisted page" do
        cms_page2 = FactoryGirl.create(:webmasters_cms_page)

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

      it "moves a child page to second place in order" do
        child_page1
        child_page2 = FactoryGirl.create(:webmasters_cms_page, parent: cms_page)
        child_page3 = FactoryGirl.create(:webmasters_cms_page, parent: cms_page)
        params = {}
        params[cms_page.id.to_s] = 'null'
        params[child_page3.id.to_s] = cms_page.id.to_s
        params[child_page1.id.to_s] = cms_page.id.to_s
        params[child_page2.id.to_s] = cms_page.id.to_s

        expect(cms_page.children(true)).to eq([child_page1, child_page2, child_page3])

        Page.update_tree(params)
        
        expect(cms_page.children(true)).to eq([child_page3, child_page1, child_page2])
      end

    end

    describe ".update_tree(invalid_hash)" do
      it "does nothing" do
        Page.update_tree({cms_page.id => cms_page.name})

        cms_page.reload

        expect(cms_page.parent_id).to be_nil
      end
    end
  end
end
