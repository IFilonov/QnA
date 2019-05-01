require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should allow_value("http://yandex.ru").for(:url) }
  it { should_not allow_value('any text').for(:url) }

  describe '#gist?' do
     let(:user) { create(:user) }
     let(:question) { create(:question, user: user) }
     let!(:link) { create(:link, linkable: question) }
     let!(:gist_link) { create(:link, :gist_link, linkable: question) }

      it 'link url should be gist' do
       expect(gist_link).to be_gist
     end

      it 'link url dont should be gist' do
       expect(link).to_not be_gist
     end
   end
end
