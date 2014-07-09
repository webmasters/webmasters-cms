require 'spec_helper'

module WebmastersCms
  module Admin
    module PageVersions
      describe PageVersionsController do
        routes { WebmastersCms::Engine.routes }

        let(:cms_page) { FactoryGirl.create(:webmasters_cms_page) }
        let(:cms_page_version) { FactoryGirl.create(:webmasters_cms_page_version, page_id: cms_page) }

        describe "GET #index" do
          before :each do
            get :index, page_id: cms_page
          end

          it "assigns the requested Page to @page" do
            expect(assigns(:page)).to eq(cms_page)
          end

          it "renders the #index view" do
            expect(response).to render_template :index
          end
        end

        describe "GET #show" do
          before :each do
            get :show, page_id: cms_page, id: cms_page_version
          end

          it "assigns all page versions to collection" do
            expect(assigns(:collection)).to eq(cms_page.versions)
          end

          it "renders the #show view" do
            expect(response).to render_template(partial: "_page")
          end
        end
      end
    end
  end
end