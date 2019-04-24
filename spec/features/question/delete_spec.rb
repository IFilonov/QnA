require 'rails_helper'

feature 'User can delete question', %q{
  As an authenticated user
  I'd like to delete user question
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Authenticated user deletes his question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content 'Your question successfully deleted'
    expect(page).not_to have_content question.title
    expect(page).not_to have_content question.body
  end

  scenario 'Authenticated user deletes not his question with errors' do
    sign_in(another_user)
    visit question_path(question)

    expect(page).not_to have_link 'Delete question'
  end

  scenario 'Unauthenticated user deletes any question with errors' do
    visit question_path(question)

    expect(page).not_to have_link 'Delete question'
  end
end
