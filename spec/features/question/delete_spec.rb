require 'rails_helper'

feature 'User can delete question', %q{
  As an authenticated user
  I'd like to delete user question
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user deletes his question' do

    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    visit new_question_path
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    click_on 'Ask'

    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content 'Your question successfully deleted'
  end

  scenario 'Authenticated user deletes not his question with errors' do

    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    click_on 'Log in'

    visit new_question_path
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    click_on 'Ask'

    click_on 'Log out'

    visit new_user_session_path

    fill_in 'Email', with: another_user.email
    fill_in 'Password', with: another_user.password
    click_on 'Log in'

    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content 'Only author can delete question'
  end
end
