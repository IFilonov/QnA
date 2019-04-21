require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    before { sign_in(user) }

    context 'with valid attributes' do
      it 'saves a new answer of question in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'redirect to question view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js
        expect(response).to render_template :create
      end

      it 'question assigned with logged in user' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js
        expect(assigns(:answer).user).to eq user
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid_answer), question_id: question }, format: :js }.to_not change(Answer, :count)
      end

      it 'render questions/show' do
        post :create, params: { answer: attributes_for(:answer, :invalid_answer), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:another_user) { create(:user) }

    context 'user delete his answer' do
      before { sign_in(user) }

      it 'delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question show' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
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

    context 'as an author' do
      before { sign_in(user) }

      it 'delete answer files' do
        answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: "rails_helper.rb")

        expect do
          delete :delete_file, params: { id: answer, file_id: answer.files.first.id }, format: :js
        end.to change(ActiveStorage::Attachment, :count).by(-1)
      end

      it 'render delete_file template' do
        answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: "rails_helper.rb")

        delete :delete_file, params: { id: answer, file_id: answer.files.first.id }, format: :js
        expect(response).to render_template :delete_file
      end
    end

    context 'user is not an author' do
      before { sign_in(another_user) }

      it 'delete the answer file' do
        answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: "rails_helper.rb")

        expect { delete :delete_file, params: { id: answer, file_id: answer.files.first.id }, format: :js }.to_not change(ActiveStorage::Attachment, :count)
        expect(response).to redirect_to answer.question
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'with valid attributes' do
      before { sign_in(user) }

      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { sign_in(user) }

      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid_answer) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid_answer) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'when user is not an author' do
      let(:another_user) { create(:user) }

      before { sign_in(another_user) }

      it 'cannot changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end

      it 'redirect to answers question view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to redirect_to answer.question
      end
    end
  end

  describe 'PATCH #best' do
    context 'user as an author of question' do
      before { sign_in(user) }
      before { patch :best, params: { id: answer, format: :js } }

      it 'make the answer the best' do
        answer.reload
        expect(answer.best).to eq true
      end

      it 'render answer best' do
        expect(response).to render_template :best
      end
    end

    context 'user a not an author of question' do
      let!(:another_user) { create(:user) }
      before { sign_in(another_user) }
      before { patch :best, params: { id: answer, format: :js } }

      it 'does not make the answer the best' do
        answer.reload
        expect(answer.best).to_not eq true
      end

      it 'redirects to question path' do
        expect(response).to redirect_to answer.question
      end
    end
  end
end
