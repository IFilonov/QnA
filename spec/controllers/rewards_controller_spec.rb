require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

   describe 'GET #index' do
    let(:rewards) { create_list(:reward, 3, question: question, user: user) }

    before do
      sign_in(user)
      get :index
    end

    it 'populates an array of all rewards' do
      expect(assigns(:rewards)).to match_array(rewards)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
