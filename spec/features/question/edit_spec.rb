require 'rails_helper'

feature 'Only author can edit question', %q{
  As an authenticated user
  I'd like to edit own question
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Authenticated user edits his question', js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_link 'Edit'
    expect(page).not_to have_button 'Save'

    click_on 'Edit'

    expect(page).not_to have_link 'Edit'
    expect(page).to have_button 'Save'

    fill_in 'question-title', with: question.title
    fill_in 'question-body', with: question.body

    click_on 'Save'

    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'author can add files when edit a question', js: true do
    sign_in(user)
    visit question_path(question)
    within '.question' do
      expect(page).to_not have_field 'question-file-field'

      click_on 'Edit'

      expect(page).to have_field 'question-file-field'
    end
  end

  scenario 'edit a question with many attached file', js: true do
    sign_in(user)
    visit question_path(question)
    within '.question' do

      click_on 'Edit'

      attach_file 'question-file-field', ["#{Rails.root}/spec/rails_helper.rb","#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Save'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user edits any question with errors', js: true do
    sign_in(another_user)
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end
end
