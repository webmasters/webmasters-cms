require 'spec_helper'

module WebmastersCms
  describe PagesController do
    routes { WebmastersCms::Engine.routes }

    describe "GET #index" do
      it "shows all available Pages" do
        page = FactoryGirl.create(:webmasters_cms_page)
        get :index
        assigns(:pages).should eq([page])
      end

      it "renders the #index view" do
        get :index
        response.should render_template :index
      end
    end

    describe "GET #show" do
      it "assigns the requested Page to @page" do
        page = FactoryGirl.create(:webmasters_cms_page)
        get :show, id: page
        assigns(:page).should eq(page)
      end

      it "renders the #show view" do
        get :show, id: FactoryGirl.create(:webmasters_cms_page)
        response.should render_template :show
      end
    end

    describe "GET #new" do
      it "assigns a new Page to @page" do
        get :new
        expect(assigns(:page)).to be_a_new(Page)
      end

      it "renders the #new view" do
        get :new
        response.should render_template :new
      end
    end

    describe "POST #create" do
      context "with valid attributes" do
        it "creates a new Page" do
          expect{
            post :create, page: FactoryGirl.attributes_for(:webmasters_cms_page)
          }.to change(Page,:count).by(1)
        end

        it "redirects to the created Page" do
          post :create, page: FactoryGirl.attributes_for(:webmasters_cms_page)
          response.should redirect_to page_path(Page.last.local_path)
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
          response.should render_template :new
        end
      end
    end

    describe "GET #edit" do
      it "assigns the requested Page to @page" do
        page = FactoryGirl.create(:webmasters_cms_page)
        get :edit, id: page
        assigns(:page).should eq(page)
      end

      it "renders the #edit view" do
        get :edit, id: FactoryGirl.create(:webmasters_cms_page)
        response.should render_template :edit
      end
    end

    describe "PUT #update" do
      before :each do
        @page = FactoryGirl.create(
          :webmasters_cms_page,
          name: "Name",
          local_path: "Localpath"
        )
      end

      context "with valid attributes" do
        it "located the requested @page" do
          put :update, id: @page, page: FactoryGirl.attributes_for(:webmasters_cms_page)
          assigns(:page).should eq(@page)
        end

        it "updates @page" do
          put :update, id: @page,
            page: FactoryGirl.attributes_for(
              :webmasters_cms_page,
              name: "UpdatedName",
              local_path: "UpdatedLocalpath"
            )
          @page.reload
          @page.name.should eq("UpdatedName")
          @page.local_path.should eq("UpdatedLocalpath")
        end

        it "redirects to the Page #show view" do
          put :update, id: @page, page: FactoryGirl.attributes_for(:webmasters_cms_page)
          @page.reload
          response.should redirect_to page_path(@page.local_path)
        end
      end

      context "with invalid attributes" do
        it "does not update the @page" do
          put :update, id: @page,
            page: FactoryGirl.attributes_for(
              :webmasters_cms_page,
              name: "UpdatedName",
              local_path: nil
            )
          @page.reload
          @page.name.should_not eq("UpdatedName")
          @page.local_path.should eq("Localpath")
        end

        it "stays on the #edit view" do
          put :update, id: @page, page: FactoryGirl.attributes_for(:invalid_webmasters_cms_page)
          response.should render_template :edit
        end
      end
    end

    describe "POST #delete" do
      before :each do
        @page = FactoryGirl.create(:webmasters_cms_page)
      end
      it "deletes the requested Page" do
        expect { delete :destroy, id: @page }.to change(Page,:count).by(-1)
      end
      it "redirects to the index" do
        delete :destroy, id: @page
        response.should redirect_to pages_path
      end
    end
  end
end
