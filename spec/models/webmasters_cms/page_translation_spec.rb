require 'spec_helper'

module WebmastersCms
  module Admin
    describe PageTranslation do

      let (:page) { create(:webmasters_cms_page) }
      let (:page_translation) { page.translations.first }

      it "has a valid factory" do
        expect(page_translation).to be_valid
      end

      describe "#name" do
        it "is invalid without an unique name" do
          translation = FactoryGirl.build(:webmasters_cms_page_translation, name: page_translation.name, page: page)
          expect(translation).to_not be_valid
          expect(translation.errors[:name]).to_not be_blank
        end

        it "is invalid without a name" do
          translation = FactoryGirl.build(:webmasters_cms_page_translation, name: nil, page: page)
          expect(translation).to_not be_valid
          expect(translation.errors[:name]).to_not be_blank
        end

        it "is invalid with a too long name" do
          translation = FactoryGirl.build(:webmasters_cms_page_translation, name: "A"*256, page: page)
          expect(translation).to_not be_valid
          expect(translation.errors[:name]).to_not be_blank
        end

        it "is valid with a long name with multibyte characters" do
          expect(FactoryGirl.build(:webmasters_cms_page_translation, name: "A"*253 + "€", page: page)).to be_valid
        end
      end

      describe "#local_path" do
        it "is valid with an alphanumeric local_path" do
          translation = FactoryGirl.build(:webmasters_cms_page_translation, local_path: "deoxyribonucleinacid", page: page)
          expect(translation).to be_valid
        end

        it "is valid with an underscore and hyphen in local_path" do
          translation = FactoryGirl.build(:webmasters_cms_page_translation, local_path: "underscore_and-hyphen", page: page)
          expect(translation).to be_valid
        end

        it "is valid without an local_path" do
          translation = build(:webmasters_cms_page_translation, :index, page: page)
          expect(translation.errors[:local_path]).to be_blank
          expect(translation).to be_valid
        end

        it "is invalid without an unique local_path" do
          translation = FactoryGirl.create(:webmasters_cms_page_translation, local_path: 'test', page: page, language: 'xx')
          translation2 = FactoryGirl.build(:webmasters_cms_page_translation, local_path: translation.local_path, page: page, language: translation.language)
          expect(translation).to be_valid
          expect(translation2).to_not be_valid
          expect(translation2.errors[:local_path]).to_not be_blank
        end

        it "is invalid with a too long local_path" do
          translation = FactoryGirl.build(:webmasters_cms_page_translation, local_path: "A"*256, page: page)
          expect(translation).to_not be_valid
          expect(translation.errors[:local_path]).to_not be_blank
        end

        it "is invalid with special characters in the local_path" do
          translation = FactoryGirl.build(:webmasters_cms_page_translation, local_path: ",.\"/?\\|[+={]';!@#$%^&*()'}", page: page)
          expect(translation).to_not be_valid
          expect(translation.errors[:local_path]).to_not be_blank
        end
      end

      describe "#title" do
        it "is invalid without a title" do
          translation = FactoryGirl.build(:webmasters_cms_page_translation, title: nil, page: page)
          expect(translation).to_not be_valid
          expect(translation.errors[:title]).to_not be_blank
        end

        it "is invalid with a too long title" do
          translation = FactoryGirl.build(:webmasters_cms_page_translation, title: "A"*256, page: page)
          expect(translation).to_not be_valid
          expect(translation.errors[:title]).to_not be_blank
        end
      end

      describe "#meta_description" do
        it "is invalid without a meta_description" do
          translation = FactoryGirl.build(:webmasters_cms_page_translation, meta_description: nil, page: page)
          expect(translation).to_not be_valid
          expect(translation.errors[:meta_description]).to_not be_blank
        end

        it "is invalid with a too long meta_description" do
          translation = FactoryGirl.build(:webmasters_cms_page_translation, meta_description: "A"*256, page: page)
          expect(translation).to_not be_valid
          expect(translation.errors[:meta_description]).to_not be_blank
        end
      end

      describe "#body" do
        it "is invalid without a body" do
          translation = FactoryGirl.build(:webmasters_cms_page_translation, body: nil, page: page)
          expect(translation).to_not be_valid
          expect(translation.errors[:body]).to_not be_blank
        end

        it "is invalid with a too long body" do
          translation = FactoryGirl.build(:webmasters_cms_page_translation, body: "A"*65536, page: page)
          expect(translation).to_not be_valid
          expect(translation.errors[:body]).to_not be_blank
        end
      end

      describe "#page_id" do
        it "is invalid without a page_id" do
          translation = FactoryGirl.build(:webmasters_cms_page_translation)
          expect(translation).to_not be_valid 
          expect(translation.errors[:page]).to_not be_blank
       end
      end
    end
  end
end
