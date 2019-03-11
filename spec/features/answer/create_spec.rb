require 'rails_helper'

feature 'User can create answer', %q{
  In order to get answer on a question
  As an authenticated user
  I'd like to answer the question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }

  scenario 'create an answer' do

    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    click_on 'Log in'

    visit question_path(question)
    fill_in 'Body', with: answer.body
    click_on 'Answer'

    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content answer.body
  end

  scenario 'make an answer with errors' do

    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    click_on 'Log in'

    visit question_path(question)
    click_on 'Answer'

    expect(page).to have_content "Body can't be blank"
  end

  scenario 'make an answer by unauthenticated user with errors' do

    visit question_path(question)
    click_on 'Answer'

    expect(page).to have_content "You need to sign in or sign up before continuing"
  end
end
