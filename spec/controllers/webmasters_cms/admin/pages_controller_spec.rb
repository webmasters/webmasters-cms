
require 'spec_helper'
module WebmastersCms
  module Admin
    describe PagesController, type: :controller do
      routes { WebmastersCms::Engine.routes }

      let (:page) { create(:webmasters_cms_page) }
      let (:page_translation) { create(:webmasters_cms_page_translation, page_id: :page) }

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
          get :show, id: page
          expect(assigns(:resource)).to eq(page)
        end

        it "renders the #show view" do
          get :show, id: page_translation
          expect(response).to render_template :show
        end

        it "renders a 404 given an invalid Id" do
          expect{get :show, id: ""}.to raise_error(ActiveRecord::RecordNotFound)
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
        context "with valid attributes" do
          it "creates a new Page" do
            expect{
              post :create, page: attributes_for(:webmasters_cms_page)
            }.to change(Page, :count).by(1)
          end

          it "redirects to the Pages overview" do
            post :create, page: attributes_for(:webmasters_cms_page)
            expect(response).to redirect_to admin_pages_path
          end
        end

        context "with invalid attributes" do
          it "does not create a new PageTranslation" do
            expect {
              post :create, page_translation: attributes_for(:invalid_webmasters_cms_page_translation)
            }.to_not change(page.translations, :count)
          end

          it "stays in the #new view" do
            post :create, id: attributes_for(:invalid_webmasters_cms_page_translation)
            expect(response).to render_template :new
          end
        end
      end

      describe "GET #edit" do
        it "assigns the requested Page to @page" do
          get :edit, id: page
          expect(assigns(:resource)).to eq(page)
        end

        it "renders the #edit view" do
          get :edit, id: page
          expect(response).to render_template :edit
        end
      end

      describe "PUT #update" do

        context "with valid attributes" do
          it "located the requested page_translation" do
            put :update, id: page, page_translation: attributes_for(:webmasters_cms_page_translation)
            expect(assigns(:resource)).to eq(page_translation)
          end

          it "updates @page_translation" do
            expect {
              put :update, id: page,
              page_translation: attributes_for(
                :webmasters_cms_page_translation,
                name: "UpdatedName",
                local_path: "UpdatedLocalpath"
              )
              page_translation.reload
            }.to change{[page_translation.name, page_translation.local_path]}
          end

          it "redirects to the Page #show view" do
            put :update, id: page_translation, page_translation: attributes_for(:webmasters_cms_page_translation)
            expect(response).to redirect_to admin_page_path(page_translation)
          end
        end

        context "with invalid attributes" do
          it "does not update the page_translation" do
            expect {
              put :update, id: page_translation,
              page_translation: attributes_for(
                :webmasters_cms_page_translation,
                local_path: nil
              )
            }.to_not change{page_translation}
          end

          it "stays on the #edit view" do
            put :update, id: page_translation, page_translation: attributes_for(:invalid_webmasters_cms_page_translation)
            expect(response).to render_template :edit
          end
        end
      end

      describe "POST #delete" do

        it "deletes the requested Page" do
          delete_cms_page = create(:webmasters_cms_page)
          expect { delete :destroy, id: delete_cms_page }.to change(Page,:count).by(-1)
        end

        it "redirects to the index" do
          delete :destroy, id: page
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

          put :sort, page: {child_page.id => parent_page.id}
          child_page.reload

          expect(response).to be_success
          expect(child_page.parent_id).to eq(parent_page.id)
        end
      end

      describe "PATCH #set_current_version" do
        it "reverts the object to an other version" do
          page_translation = create(:webmasters_cms_page_translation)
          page_translation_version =
            create(:webmasters_cms_page_translation_version,
              page_translation_id: page_translation.id,
              version: page_translation.version + 1)
          patch :set_current_version,
            id: page_translation.id,
            page: { version: page_translation_version.version }
          page_translation.reload
          expect(page_translation.version).to eq(page_translation_version.version)
        end
      end
    end
  end
end