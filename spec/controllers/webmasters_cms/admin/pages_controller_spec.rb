
require 'spec_helper'
module WebmastersCms
  module Admin
    describe PagesController do
      routes { WebmastersCms::Engine.routes }

      let (:cms_page) { FactoryGirl.create(:webmasters_cms_page) }

      describe "GET #index" do
        before :each do
          get :index
        end

        it "shows all available Pages" do
          expect(assigns(:collection)).to eq([cms_page])
        end

        it "renders the #index view" do
          expect(response).to render_template :index
        end
      end

      describe "GET #show" do
        it "assigns the requested Page to @resource" do
          get :show, id: cms_page
          expect(assigns(:resource)).to eq(cms_page)
        end

        it "renders the #show view" do
          get :show, id: cms_page
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
              post :create, page: FactoryGirl.attributes_for(:webmasters_cms_page)
            }.to change(Page, :count).by(1)
          end

          it "redirects to the Pages overview" do
            post :create, page: FactoryGirl.attributes_for(:webmasters_cms_page)
            expect(response).to redirect_to admin_pages_path
          end
        end

        context "with invalid attributes" do
          it "does not create a new Page" do
            expect {
              post :create, page: FactoryGirl.attributes_for(:invalid_webmasters_cms_page)
            }.to_not change(Page,:count)
          end

          it "stays in the #new view" do
            post :create, page: FactoryGirl.attributes_for(:invalid_webmasters_cms_page)
            expect(response).to render_template :new
          end
        end
      end

      describe "GET #edit" do
        it "assigns the requested Page to @page" do
          get :edit, id: cms_page
          expect(assigns(:resource)).to eq(cms_page)
        end

        it "renders the #edit view" do
          get :edit, id: cms_page
          expect(response).to render_template :edit
        end
      end

      describe "PUT #update" do

        context "with valid attributes" do
          it "located the requested cms_page" do
            put :update, id: cms_page, page: FactoryGirl.attributes_for(:webmasters_cms_page)
            expect(assigns(:resource)).to eq(cms_page)
          end

          it "updates @page" do
            expect {
              put :update, id: cms_page,
              page: FactoryGirl.attributes_for(
                :webmasters_cms_page,
                name: "UpdatedName",
                local_path: "UpdatedLocalpath"
              )
              cms_page.reload
            }.to change{[cms_page.name, cms_page.local_path]}
          end

          it "redirects to the Page #show view" do
            put :update, id: cms_page, page: FactoryGirl.attributes_for(:webmasters_cms_page)
            expect(response).to redirect_to admin_page_path(cms_page)
          end
        end

        context "with invalid attributes" do
          it "does not update the cms_page" do
            expect {
              put :update, id: cms_page,
              page: FactoryGirl.attributes_for(
                :webmasters_cms_page,
                local_path: nil
              )
            }.to_not change{cms_page}
          end

          it "stays on the #edit view" do
            put :update, id: cms_page, page: FactoryGirl.attributes_for(:invalid_webmasters_cms_page)
            expect(response).to render_template :edit
          end
        end
      end

      describe "POST #delete" do

        it "deletes the requested Page" do
          delete_cms_page = FactoryGirl.create(:webmasters_cms_page)
          expect { delete :destroy, id: delete_cms_page }.to change(Page,:count).by(-1)
        end

        it "redirects to the index" do
          delete :destroy, id: cms_page
          expect(response).to redirect_to admin_pages_path
        end
      end

      describe "PUT #sort" do
        it "does not redirect" do
          expect { put :sort }.to render_template nil
        end

        it "updates the tree" do
          child_page = FactoryGirl.create(:webmasters_cms_page)
          parent_page = FactoryGirl.create(:webmasters_cms_page)

          put :sort, page: {child_page.id => parent_page.id}
          child_page.reload

          expect(response).to be_success
          expect(child_page.parent_id).to eq(parent_page.id)
        end
      end

      describe "PATCH #set_current_version" do
        it "reverts the object to an other version" do
          cms_page = FactoryGirl.create(:webmasters_cms_page)
          cms_page_version = FactoryGirl.create(:webmasters_cms_page_version, page_id: cms_page.id, version: cms_page.version + 1)
          patch :set_current_version, id: cms_page.id, page: { version: cms_page_version.version }
          cms_page.reload
          expect(cms_page.version).to eq(cms_page_version.version)
        end
      end
    end
  end
end