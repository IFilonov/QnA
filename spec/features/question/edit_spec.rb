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

  scenario 'Unauthenticated user edits any question with errors', js: true do
    sign_in(another_user)
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end
end
