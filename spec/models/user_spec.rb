require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author?' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }

    it 'when question owner is user' do
      question = create(:question, user: user)

      expect(user.author_of?(question)).to eq true
    end

    it 'when question owner is an another user' do
      question = create(:question, user: another_user)

      expect(user.author_of?(question)).to eq false
    end
  end
end
