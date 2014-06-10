require 'spec_helper'

module WebmastersCms
  describe Page do
    it "has a valid factory" do
      expect(FactoryGirl.create(:webmasters_cms_page)).to be_valid
    end

    describe "#name" do
      it "is invalid without an unique name" do
        page1 = FactoryGirl.create(:webmasters_cms_page, name: "Page", local_path: "localpath1")
        page2 = FactoryGirl.build(:webmasters_cms_page, name: "Page", local_path: "localpath2")
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
        page1 = FactoryGirl.create(:webmasters_cms_page, name: "Page1", local_path: "localpath")
        page2 = FactoryGirl.build(:webmasters_cms_page, name: "Page2", local_path: "localpath")
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
  end
end
