require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should have_many(:links).dependent(:destroy) }

  it { should have_db_index :question_id }
  it { should have_db_index :user_id }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  describe '#best!' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:another_answer) { create(:answer, question: question, user: another_user) }
    let!(:reward) { create(:reward, question: question) }

    it 'should make answer the best' do
      answer.best!

      expect(answer).to be_best
    end

    it 'only one answer can be the best' do
      another_answer = create(:answer, question: question, user: user, best: true)

      expect(another_answer).to be_best

      answer.best!
      another_answer.reload

      expect(answer).to be_best
      expect(another_answer).to_not be_best
    end

    it 'best answer is first in list' do
      another_answer.best!
      expect(another_answer).to eq question.answers.first
    end

    it 'have many attached file' do
      expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end

    it 'award user by the question reward for best answer' do
      another_answer.best!
      expect(reward).to eq another_user.rewards.last
    end
  end
end
