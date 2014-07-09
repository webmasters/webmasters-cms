require 'spec_helper'

module WebmastersCms
  describe PagesController do
    describe 'POST #preview' do
      routes { WebmastersCms::Engine.routes }

      let (:cms_page) { FactoryGirl.build(:webmasters_cms_page) }

      it 'assigns the unsaved Page to resource' do
        post :preview, page: cms_page.attributes
        expect(assigns(:resource)).to be_instance_of(WebmastersCms::Page)
      end

      it "renders the #preview view" do
        post :preview, page: cms_page.attributes
        expect(response).to render_template :show
      end
    end
  end
end
