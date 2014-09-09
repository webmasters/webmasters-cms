require 'spec_helper'

module WebmastersCms
  module Admin
    describe PageTranslation do

      let (:active_language) { create(:webmasters_cms_active_language) }
      let (:page) { create(:webmasters_cms_page) }
      let (:page_translation) { create(:webmasters_cms_page_translation, language: active_language.code.to_s, page_id: page) }

      it "has a valid factory" do
        expect(page_translation).to be_valid
      end

      describe "#name" do
        it "is invalid without an unique name" do
          page2 = FactoryGirl.build(:webmasters_cms_page_translation, name: page_translation.name)
          expect(page2).to_not be_valid
        end

        it "is invalid without a name" do
          expect(FactoryGirl.build(:webmasters_cms_page_translation, name: nil)).to_not be_valid
        end

        it "is invalid with a too long name" do
          expect(FactoryGirl.build(:webmasters_cms_page_translation, name: "A"*256)).to_not be_valid
        end

        it "is valid with a long name with multibyte characters" do
          expect(FactoryGirl.build(:webmasters_cms_page_translation, name: "A"*253 + "€")).to be_valid
        end
      end

      describe "#local_path" do
        it "is valid with an alphanumeric local_path" do
          expect(FactoryGirl.build(:webmasters_cms_page_translation, local_path: "deoxyribonucleinacid")).to be_valid
        end

        it "is valid with an underscore and hyphen in local_path" do
          expect(FactoryGirl.build(:webmasters_cms_page_translation, local_path: "underscore_and-hyphen")).to be_valid
        end

        it "is invalid without an unique local_path" do
          page2 = FactoryGirl.build(:webmasters_cms_page_translation, local_path: page_translation.local_path)
          expect(page2).to_not be_valid
        end

        it "is invalid with a too long local_path" do
          expect(FactoryGirl.build(:webmasters_cms_page_translation, local_path: "A"*256)).to_not be_valid
        end

        it "is invalid with special characters in the local_path" do
          expect(FactoryGirl.build(:webmasters_cms_page_translation, local_path: ",.\"/?\\|[+={]';!@#$%^&*()'}")).to_not be_valid
        end
      end

      describe "#title" do
        it "is invalid without a title" do
          expect(FactoryGirl.build(:webmasters_cms_page_translation, title: nil)).to_not be_valid
        end

        it "is invalid with a too long title" do
          expect(FactoryGirl.build(:webmasters_cms_page_translation, title: "A"*256)).to_not be_valid
        end
      end

      describe "#meta_description" do
        it "is invalid without a meta_description" do
          expect(FactoryGirl.build(:webmasters_cms_page_translation, meta_description: nil)).to_not be_valid
        end

        it "is invalid with a too long meta_description" do
          expect(FactoryGirl.build(:webmasters_cms_page_translation, meta_description: "A"*256)).to_not be_valid
        end
      end

      describe "#body" do
        it "is invalid without a body" do
          expect(FactoryGirl.build(:webmasters_cms_page_translation, body: nil)).to_not be_valid
        end

        it "is invalid with a too long body" do
          expect(FactoryGirl.build(:webmasters_cms_page_translation, body: "A"*65536)).to_not be_valid
        end
      end
    end
  end
end
