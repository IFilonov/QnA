require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to ask the question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user asks a question' do

    sign_in(user)

    visit new_question_path
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    click_on 'Ask'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'asks a question by authenticated user with errors' do

    sign_in(user)

    visit new_question_path
    click_on 'Ask'

    expect(page).to have_content "Title can't be blank"
  end

  scenario 'asks a question by unauthenticated user with errors' do
    visit new_question_path

    expect(page).to have_content "You need to sign in or sign up before continuing"
  end

end
