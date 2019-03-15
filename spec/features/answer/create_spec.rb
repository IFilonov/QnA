require 'rails_helper'

feature 'User can create answer', %q{
  In order to get answer on a question
  As an authenticated user
  I'd like to answer the question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'create an answer' do
    sign_in(user)

    visit question_path(question)
    fill_in 'Body', with: "Answer body"
    click_on 'Answer'

    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content "Answer body"
  end

  scenario 'make an answer with errors' do
    sign_in(user)

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
