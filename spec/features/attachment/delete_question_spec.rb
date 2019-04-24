require 'rails_helper'

feature 'User can remove his question attachments', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be remove my question attachments
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    before do
      sign_in(user)
      question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: "rails_helper.rb")
      question.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: "spec_helper.rb")
      visit question_path(question)
    end

    scenario 'author of the question removes the attachment' do
      within ".attachment-#{question.files.first.id}" do
        click_on 'Delete'
      end

      within ".attachment-#{question.files.last.id}" do
        click_on 'Delete'
      end

      within ".question" do
        expect(page).to_not have_link 'rails_helper.rb'
        expect(page).to_not have_link 'spec_helper.rb'
      end
    end

    scenario 'not author of the question removes the attachment' do
      click_on 'Log out'
      sign_in(another_user)
      visit question_path(question)

      within ".attachment-#{question.files.first.id}" do
        expect(page).to_not have_link 'Delete'
      end
    end

    scenario 'Not authenticated user delete question attachment' do
      click_on 'Log out'
      visit question_path(question)

      within ".attachment-#{question.files.first.id}" do
        expect(page).to_not have_link 'Delete'
      end
    end
  end
end
