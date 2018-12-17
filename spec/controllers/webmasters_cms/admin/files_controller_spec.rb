require 'spec_helper'

module WebmastersCms
  RSpec.describe Admin::FilesController, type: :controller do
    routes { Engine.routes }
    render_views
    
    describe 'On POST :create with valid attrs' do
      let(:expect_block) do
        lambda do
          post :create, :params => {:upload => FactoryBot.attributes_for(:webmasters_cms_file_controller)[:file]}
        end
      end

      it "results in a success" do
        expect_block.call
        expect(response).to be_successful
      end

      it "renders no template" do
        expect_block.call
        expect(response).to render_template nil
      end

      it "creates a file" do
        expect(expect_block).to change(WebmastersCms::File, :count).by(1)
      end
    end
  end
end
