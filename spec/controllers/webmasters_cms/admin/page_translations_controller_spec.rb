require 'spec_helper'

module WebmastersCms
  module Admin
    describe PageTranslationsController, type: :controller do
      routes { WebmastersCms::Engine.routes }

      let(:page) { create(:webmasters_cms_page) }
      let(:page_translation) { create(:webmasters_cms_page_translation, page_id: page) }

      context "with invalid attributes" do
        it "does not create a new PageTranslation" do
          expect {
            post :create, page: attributes_for(:invalid_webmasters_cms_page_translation)}}
          }.to_not change(page.translations, :count)
        end

        it "stays in the #new view" do
          post :create, id: attributes_for(:invalid_webmasters_cms_page_translation)
          expect(response).to render_template :new
        end
      end
    end
  end
end