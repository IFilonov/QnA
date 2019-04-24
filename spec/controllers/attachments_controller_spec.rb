require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'DELETE #destroy' do
    before do
      sign_in(user)
      question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: "rails_helper.rb")
      answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: "rails_helper.rb")
    end

    context 'user an author' do

      it 'delete question attachment' do
        expect do
          delete :destroy, params: { id: question.files.first }, format: :js
        end.to change(ActiveStorage::Attachment, :count).by(-1)
      end

      it 're-render question show' do
        delete :destroy, params: { id: question.files.first }, format: :js
        expect(response).to render_template :destroy
      end

      it 'delete answer attachment' do
        expect do
          delete :destroy, params: { id: answer.files.first }, format: :js
        end.to change(ActiveStorage::Attachment, :count).by(-1)
      end

      it 're-render question show' do delete :destroy, params: { id: answer.files.first }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'user is not an author' do
      before { sign_in(another_user) }

      it 'delete the question attachment' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js}.to_not change(ActiveStorage::Attachment, :count)
      end

      it 'delete the answer attachment' do
        expect { delete :destroy, params: { id: answer.files.first }, format: :js}.to_not change(ActiveStorage::Attachment, :count)
      end
    end
  end
end
