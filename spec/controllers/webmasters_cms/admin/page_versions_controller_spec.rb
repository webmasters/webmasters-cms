require 'spec_helper'

module WebmastersCms
  module Admin
    module PageTranslationVersion
      describe PageTranslationVersionsController do
        routes { WebmastersCms::Engine.routes }

        let(:test_page_translation) { FactoryGirl.build(:webmasters_cms_page_translation) }

        describe "GET #index" do
          before :each do
            get :index, page_id: test_page
          end

          it "assigns the requested Page to @page_translation" do
            expect(assigns(:page_translation)).to eq(test_page_translation)
          end

          it "routes to the right path" do
            expect(get("/index")).to route_to("webmasters_cms/admin/page_translation_versions#index")
          end

          it "renders the #index view" do
            expect(response).to render_template :index
          end
        end

        describe "GET #show" do
          before :each do
            get :show, page_id: test_page_translation, id: test_page_translation.versions.first
          end

          it "assigns all page versions to collection" do
            expect(assigns(:collection)).to eq(test_page_translation.versions)
          end

          it "routes to the right path" do
            expect(response).to route_to("webmasters_cms/admin/page_translation_versions#show")
          end

          it "renders the #show view" do
            expect(response).to render_template(partial: "_page")
          end
        end
      end
    end
  end
end