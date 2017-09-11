require 'spec_helper'

module WebmastersCms
  describe PagesController, type: :controller do
    
    describe 'POST #preview' do
      routes { ::WebmastersCms::Engine.routes }

      let (:cms_page) { build(:webmasters_cms_page) }

      it 'assigns the unsaved PageTranslation to resource' do
        post :preview, params: {page: cms_page.attributes}
        expect(assigns(:resource)).to be_instance_of(::WebmastersCms::PageTranslation)
        expect(assigns(:resource)).to be_new_record
      end

      it "renders the #preview view" do
        post :preview, params: {page: cms_page.attributes}
        expect(response).to render_template :show
      end
    end
    
    describe 'GET #show with not_existing local_path' do
      it "raises ActiveRecord::RecordNotFound" do
        expect do 
          get :show, params: {language: 'en', local_path: 'not_exist'}
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
    
    describe 'GET #show with existing local_path' do
      let(:cms_page_translation) do 
        attributes = build(:webmasters_cms_page_translation, :local_path => 'test_path').attributes
        page = create(:webmasters_cms_page, :translations_attributes => attributes)
        page.translations.first
      end

      it "render show page" do
        get :show, params: {language: cms_page_translation.language, 
          local_path: cms_page_translation.local_path}
        
        expect(response).to be_success
        expect(response).to render_template :show
      end
    end
    
    describe 'GET #show with existing local_path and wrong language' do
      let(:cms_page_translation) do 
        attributes = build(:webmasters_cms_page_translation, 
          :local_path => 'test_path', :language => 'de').attributes
        page = create(:webmasters_cms_page, :translations_attributes => attributes)
        page.translations.first
      end

      it "render ActiveRecord::RecordNotFound" do
        expect do 
          get :show, params: {language: 'en',
            local_path: cms_page_translation.local_path}
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
    
    describe 'GET #show with existing local_path and translation has a redirect_to' do
      let(:cms_page_translation) do 
        attributes = build(:webmasters_cms_page_translation, 
          :redirect_to => 'other_path').attributes
        page = create(:webmasters_cms_page, :translations_attributes => attributes)
        page.translations.first
      end

      it "redirect_to path" do
        get :show, params: {language: cms_page_translation.language, 
          local_path: cms_page_translation.local_path}
        
        expect(response).to be_redirect
        expect(response).to redirect_to(cms_page_translation.redirect_to)
      end
    end
    
    describe 'GET #show with existing local_path and translation has a redirect_to_child and no child exist' do
      let(:cms_page_translation) do 
        attributes = build(:webmasters_cms_page_translation, 
          :redirect_to_child => true).attributes
        page = create(:webmasters_cms_page, :translations_attributes => attributes)
        page.translations.first
      end

      it "reder show page" do
        get :show, params: {language: cms_page_translation.language, 
          local_path: cms_page_translation.local_path}
        
        expect(response).to be_success
        expect(response).to render_template :show
      end
    end
    
    describe 'GET #show with existing local_path and translation has a redirect_to_child and one child exist' do
      let(:cms_page_translation_parent) do 
        attributes = build(:webmasters_cms_page_translation, 
          :redirect_to_child => true).attributes
        page = create(:webmasters_cms_page, :translations_attributes => attributes)
        page.translations.first
      end
      
      let(:cms_page_translation_child) do 
        attributes = build(:webmasters_cms_page_translation, 
          :redirect_to_child => true, 
          :language => cms_page_translation_parent.language).attributes
        page = create(:webmasters_cms_page, :translations_attributes => attributes, 
          :parent => cms_page_translation_parent.page)
        page.translations.first
      end

      it "redirect_to child_page" do
        cms_page_translation_child
        get :show, params: {language: cms_page_translation_parent.language, 
          local_path: cms_page_translation_parent.local_path}
        
        expect(response).to be_redirect
        expect(response).to redirect_to(cms_page_translation_child.local_path)
      end
    end
    
    describe 'GET #show with existing local_path and translation has a redirect_to_child and the child has an other language' do
      let(:cms_page_translation_parent) do 
        attributes = build(:webmasters_cms_page_translation, 
          :redirect_to_child => true, :language => 'de').attributes
        page = create(:webmasters_cms_page, :translations_attributes => attributes)
        page.translations.first
      end
      
      let(:cms_page_translation_child) do 
        attributes = build(:webmasters_cms_page_translation, 
          :redirect_to_child => true, 
          :language => 'en').attributes
        page = create(:webmasters_cms_page, :translations_attributes => attributes, 
          :parent => cms_page_translation_parent.page)
        page.translations.first
      end

      it "render show page" do
        cms_page_translation_child
        get :show, params: {language: cms_page_translation_parent.language, 
          local_path: cms_page_translation_parent.local_path}
        
        expect(response).to be_success
        expect(response).to render_template :show
      end
    end
  end
end
