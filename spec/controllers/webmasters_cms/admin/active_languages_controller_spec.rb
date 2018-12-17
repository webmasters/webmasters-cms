require 'spec_helper'

module WebmastersCms
  module Admin
    describe ActiveLanguagesController, type: :controller do
      routes { Engine.routes }
      render_views

      describe "GET #index" do
        before :each do
          get :index
        end

        it "assigns collection to all ActiveLanguages" do
          expect(assigns(:collection)).to eq(ActiveLanguage.all)
        end

        it "renders the index template" do
          expect(response).to render_template :index
        end

        it "results in a success" do
          expect(response).to be_successful
        end
      end

      describe "GET #new" do
        before :each do
          get :new
        end
        it "assigns a new ActiveLanguage to resource" do
          expect(assigns(:resource)).to be_a_new(ActiveLanguage)
        end

        it "renders the #new view" do
          expect(response).to render_template :new
        end

        it "results in a success" do
          expect(response).to be_successful
        end
      end

      describe "POST #create" do
        context "with valid attributes" do
          let(:expect_block) do
            lambda do
              post :create, params: { active_language: { code: 'en' } }
            end
          end

          it "redirects to index" do
            expect_block.call
            expect(response).to redirect_to admin_active_languages_path
          end

          it "creates an ActiveLanguage" do
            expect(expect_block).to change(ActiveLanguage, :count).by(1)
          end

          it "creates a Page" do
            expect(expect_block).to change(Page, :count).by(1)
          end

          it "creates a PageTranslation" do
            expect(expect_block).to change(PageTranslation, :count).by(1)
          end
        end
      end
    end
  end
end
