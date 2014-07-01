require 'spec_helper'

module WebmastersCms
  describe Page do
    it "has a valid factory" do
      expect(FactoryGirl.create(:webmasters_cms_page)).to be_valid
    end

    describe "#name" do
      it "is invalid without an unique name" do
        page1 = FactoryGirl.create(:webmasters_cms_page)
        page2 = FactoryGirl.build(:webmasters_cms_page, name: page1.name)
        expect(page2).to_not be_valid
      end

      it "is invalid without a name" do
        expect(FactoryGirl.build(:webmasters_cms_page, name: nil)).to_not be_valid
      end

      it "is invalid with a too long name" do
        expect(FactoryGirl.build(:webmasters_cms_page, name: "A"*256)).to_not be_valid
      end

      it "is valid with a long name with multibyte characters" do
        expect(FactoryGirl.create(:webmasters_cms_page, name: "A"*253 + "€€")).to be_valid
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
        page1 = FactoryGirl.create(:webmasters_cms_page)
        page2 = FactoryGirl.build(:webmasters_cms_page, local_path: page1.local_path)
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
        page1 = FactoryGirl.create(:webmasters_cms_page)
        page2 = FactoryGirl.create(:webmasters_cms_page)

        expect(Page.without_page(Page.new)).to include(page1)
        expect(Page.without_page(Page.new)).to include(page2)
      end
    end

    describe ".without_page(persisted_page)" do
      it "returns a collection without the persisted page" do
        page1 = FactoryGirl.create(:webmasters_cms_page)
        page2 = FactoryGirl.create(:webmasters_cms_page)

        expect(Page.without_page(page2)).to include(page1)
        expect(Page.without_page(page2)).to_not include(page2)
      end
    end

    describe ".update_parents(valid_hash)" do
      it "updates the parent_id (value) of the page_id (key)" do
        child_page = FactoryGirl.create(:webmasters_cms_page)
        parent_page = FactoryGirl.create(:webmasters_cms_page)

        Page.update_parents({child_page.id => parent_page.id})

        child_page.reload

        expect(child_page.parent_id).to eq(parent_page.id)
      end

      it "translates parent_id 'null' to parent_id nil" do
        parent_page = FactoryGirl.create(:webmasters_cms_page)
        child_page = FactoryGirl.create(:webmasters_cms_page, parent_id: parent_page.id)

        Page.update_parents({child_page.id => 'null'})

        child_page.reload

        expect(child_page.parent_id).to be_nil
      end
    end

    describe ".update_parents(invalid_hash)" do
      it "does nothing" do
        child_page = FactoryGirl.create(:webmasters_cms_page)

        Page.update_parents({child_page.id => child_page.name})

        child_page.reload

        expect(child_page.parent_id).to be_nil
      end
    end
  end
end
