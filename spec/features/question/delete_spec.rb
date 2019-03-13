require 'rails_helper'

feature 'User can delete question', %q{
  As an authenticated user
  I'd like to delete user question
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user deletes his question' do

    sign_in(user)

    visit new_question_path
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    click_on 'Ask'

    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content 'Your question successfully deleted'
  end

  scenario 'Authenticated user deletes not his question with errors' do

    sign_in(user)

    visit new_question_path
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    click_on 'Ask'

    click_on 'Log out'

    sign_in(another_user)

    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content 'Only author can delete question'
  end
end
