require 'spec_helper'

module WebmastersCms
  RSpec.describe File, type: :model do
    context 'Given a new file' do
      subject { FactoryBot.build :webmasters_cms_file }
      it 'should be valid' do
        expect(subject.valid?).to eq true
      end

      context 'and #save' do
        it 'should create file' do
          expect do
            subject.save!
          end.to change(::WebmastersCms::File, :count).by(1)
        end
      end
    end
  end
end
