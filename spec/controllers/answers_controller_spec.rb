require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    before { sign_in(user) }

    context 'with valid attributes' do
      it 'saves a new answer of question in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(question.answers, :count).by(1)
      end

      it 'redirect to question view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question
      end

      it 'question assigned with logged in user' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(assigns(:answer).user).to eq answer.user
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid_answer), question_id: question } }.to_not change(Answer, :count)
      end

      it 'render questions/show' do
        post :create, params: { answer: attributes_for(:answer, :invalid_answer), question_id: question }
        expect(response).to render_template 'questions/show'
      end
    end
  end

    describe 'DELETE #destroy' do
    let(:another_user) { create(:user) }

    context 'user delete his answer' do
      before { sign_in(user) }

      it 'delete the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(question.answers, :count).by(-1)
      end

      it 'redirects to question show' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question
      end
    end

    context 'user try delete not his answer' do
      before { sign_in(another_user) }

      it 'delete the question' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirects to question show' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to answer.question
      end
    end
  end
end
