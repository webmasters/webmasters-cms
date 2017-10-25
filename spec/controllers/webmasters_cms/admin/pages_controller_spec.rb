require 'spec_helper'

module WebmastersCms
  module Admin
    describe PagesController, type: :controller do
      routes { ::WebmastersCms::Engine.routes }
      render_views

      let (:page) { create(:webmasters_cms_page) }
      let (:page_translation) { page.translations.first }

      describe "GET #index" do
        before :each do
          get :index
        end

        it "shows all available Pages" do
          expect(assigns(:collection)).to eq([page])
        end

        it "renders the #index view" do
          expect(response).to render_template :index
        end
      end

      describe "GET #show" do
        it "assigns the requested Page to @resource" do
          get :show, params: {id: page, language: page_translation.language}
          expect(assigns(:resource)).to eq(page)
        end

        it "renders the #show view" do
          get :show, params: {id: page, language: page_translation.language}
          expect(response).to render_template :show
        end

        it "renders a 404 given an invalid Id" do
          expect{get :show, params: {id: ""} }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      describe "GET #new" do
        before :each do
          get :new
        end
        it "assigns a new Page to @resource" do
          expect(assigns(:resource)).to be_a_new(Page)
        end

        it "renders the #new view" do
          expect(response).to render_template :new
        end
      end

      describe "POST #create" do
        before :each do 
          @active_language = FactoryBot.create(:webmasters_cms_active_language)
        end

        context "with valid attributes" do
          it "creates a new Page" do
            expect do
              page_params = attributes_for :webmasters_cms_page, 
                translations_attributes: [
                  attributes_for(:webmasters_cms_page_translation, 
                    language: @active_language.code)]

              post :create, params: { page:  page_params}
            end.to change(Page, :count).by(1)
          end

          it "creates a new PageTranslation" do
            expect do
              page_params = attributes_for :webmasters_cms_page, 
                translations_attributes: [
                  attributes_for(:webmasters_cms_page_translation, 
                    language: @active_language.code)]

              post :create, params: { page:  page_params}
            end.to change(PageTranslation, :count).by(1)
          end

          it "redirects to the Pages overview" do
            page_params = attributes_for :webmasters_cms_page, 
              translations_attributes: [
                attributes_for(:webmasters_cms_page_translation, 
                  language: @active_language.code)]

            post :create, params: {page: page_params}
            
            expect(response).to redirect_to admin_pages_path
          end
        end

        context "with invalid attributes" do
          it "does not create a new Page" do
            expect do
              page_params = attributes_for :webmasters_cms_page, 
                translations_attributes: [
                  attributes_for(:webmasters_cms_page_translation, :invalid)]

              post :create, params: { page:  page_params}
            end.to_not change(Page, :count)
          end

          it "does not create a new PageTranslation" do
            expect do
              page_params = attributes_for :webmasters_cms_page, 
                translations_attributes: [
                  attributes_for(:webmasters_cms_page_translation, :invalid)]

              post :create, params: { page:  page_params}
            end.to_not change(PageTranslation, :count)
          end

          it "stays in the #new view" do
            page_params = attributes_for :webmasters_cms_page, 
              translations_attributes: [
                attributes_for(:webmasters_cms_page_translation, :invalid)]

            post :create, params: { page:  page_params}

            expect(response).to be_success
            expect(response).to render_template :new
          end
        end
      end

      describe "GET #edit" do
        it "assigns the requested Page to @page" do
          get :edit, params: { id: page }
          expect(assigns(:resource)).to eq(page)
        end

        it "renders the #edit view" do
          get :edit, params: { id: page }
          expect(response).to render_template :edit
        end
      end

      describe "PUT #update" do

        context "with valid attributes" do
          let(:expect_block) do
            lambda do
              params = attributes_for(
                  :webmasters_cms_page,
                    translations_attributes: [
                      attributes_for(:webmasters_cms_page_translation,
                        name: "UpdatedName",
                        local_path: "UpdatedLocalpath",
                        id: page_translation.id,
                        language: page_translation.language
                      )
                    ]
              )
              put :update, params: { id: page_translation.page_id, page: params }

              page_translation.reload
            end
          end

          it "updates page_translation" do
            expect(expect_block).to change{[page_translation.name, page_translation.local_path]}
          end

          it "redirects to the Pages overview" do
            expect_block.call
            expect(response).to redirect_to admin_pages_path
          end

          it "has no error messages" do
            expect(page_translation.errors.full_messages).to be_blank
          end
        end

        context "with invalid attributes" do
          let(:expect_block) do
            lambda do
              page_params = attributes_for :webmasters_cms_page,
                  translations_attributes: [
                    attributes_for(:webmasters_cms_page_translation, :invalid,
                      name: 'other',
                      id: page_translation.id,
                      language: page_translation.language)]

              put :update, params: { id: page_translation.page_id, page: page_params }

              page_translation.reload
            end
          end

          it "does not update the page_translation" do
            expect(expect_block).to_not change { page_translation.name }
          end

          it "stays on the #edit view" do
            expect_block.call
            expect(response).to render_template :edit
          end
        end
      end

      describe "POST #delete" do

        it "deletes the requested Page" do
          delete_cms_page = create(:webmasters_cms_page)
          expect { delete :destroy, params: {id: delete_cms_page} }.to change(Page,:count).by(-1)
        end

        it "redirects to the index" do
          delete :destroy, params: {id: page}
          expect(response).to redirect_to admin_pages_path
        end
      end

      describe "PUT #sort" do
        it "does not redirect" do
          expect(put :sort).to_not render_template :index
        end

        it "updates the tree" do
          child_page = create(:webmasters_cms_page)
          parent_page = create(:webmasters_cms_page)

          put :sort, params: {page: {child_page.id => parent_page.id} }
          child_page.reload

          expect(response).to be_success
          expect(child_page.parent_id).to eq(parent_page.id)
        end
      end

      describe "PATCH #set_current_version" do
        it "reverts the object to an other version" do
          translation = create(:webmasters_cms_page_translation, page: page, language: 'xx')
          translation_version =
            create(:webmasters_cms_page_translation_version,
              page_translation: translation,
              version: translation.version)
          translation_version2 =
            create(:webmasters_cms_page_translation_version,
              page_translation: translation,
              version: translation.version + 1)
          
          patch :set_current_version,
            params: {id: translation.id, 
              page_translation: { version: translation_version.version } }

          translation.reload

          expect(translation.version).to eq(translation_version.version)
        end
      end
    end
  end
end
