require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, user: user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end


    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { sign_in(user) }
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { sign_in(user) }
    before { get :edit, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { sign_in(user) }
    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
        expect(assigns(:question).user).to eq user
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end


      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { sign_in(user) }

    context 'as an author of question with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to updated question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to redirect_to question
      end
    end

    context 'as an author of question with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

      it 'does not change question' do
        question.reload

        expect(question.title).to start_with 'MyString'
        expect(question.body).to start_with 'MyBody'
      end

      it 're-renders edit view' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'as a not author of question' do
      let(:another_user) { create(:user) }
      let!(:question) { create(:question, user: user) }

      before { sign_in(another_user) }
      it 'does not change question' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js

        question.reload

        expect(question.title).to_not eq 'new title'
        expect(question.body).to_not eq 'new body'
      end

      it 'redirect to question' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        expect(response).to redirect_to question
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:another_user) { create(:user) }
    let!(:question) { create(:question, user: user) }

    context 'user delete his question' do
      before { sign_in(user) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'user delete not his question' do
      before { sign_in(another_user) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to question path' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to question
      end
    end

    context 'as an author' do
      before { sign_in(user) }

      it 'delete question files' do
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: "rails_helper.rb")

        expect do
          delete :delete_file, params: { id: question, file_id: question.files.first.id }, format: :js
        end.to change(ActiveStorage::Attachment, :count).by(-1)
      end

      it 'render delete_file template' do
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: "rails_helper.rb")

        delete :delete_file, params: { id: question, file_id: question.files.first.id }, format: :js
        expect(response).to render_template :delete_file
      end
    end

    context 'user is not an author' do
      before { sign_in(another_user) }

      it 'delete the question file' do
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: "rails_helper.rb")

        expect { delete :delete_file, params: { id: question, file_id: question.files.first.id }, format: :js }.to_not change(ActiveStorage::Attachment, :count)
        expect(response).to redirect_to question
      end
    end
  end
end
