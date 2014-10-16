require 'spec_helper'

module WebmastersCms
  describe PagesController, type: :controller do
    routes { ::WebmastersCms::Engine.routes }
    
    describe 'POST #preview' do

      let (:cms_page) { build(:webmasters_cms_page) }

      it 'assigns the unsaved PageTranslation to resource' do
        post :preview, page: cms_page.attributes
        expect(assigns(:resource)).to be_instance_of(::WebmastersCms::PageTranslation)
      end

      it "renders the #preview view" do
        post :preview, page: cms_page.attributes
        expect(response).to render_template :show
      end
    end
  end
end
