require 'rails_helper'

feature 'User can remove his answer attachments', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be remove my answer attachments
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user', js: true do
    before do
      sign_in(user)
      answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: "rails_helper.rb")
      answer.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: "spec_helper.rb")
      visit question_path(question)
    end

    scenario 'author of the answer removes the attachment', js: true do
      within ".attachment-#{answer.files.first.id}" do
        click_on 'Delete'
      end

      within ".answers" do
        expect(page).to_not have_link 'rails_helper.rb'
      end
    end

    scenario 'not author of the answer removes the attachment', js: true do
      click_on 'Log out'
      sign_in(another_user)
      visit question_path(question)

      within ".attachment-#{answer.files.first.id}" do
        expect(page).to_not have_link 'Delete'
      end
    end

    scenario 'Not authenticated user delete question attachment', js: true do
      click_on 'Log out'
      visit question_path(question)

      within ".attachment-#{answer.files.first.id}" do
        expect(page).to_not have_link 'Delete'
      end
    end
  end
end
