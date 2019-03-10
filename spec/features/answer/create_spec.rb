require 'rails_helper'

feature 'User can create answer', %q{
  In order to get answer on a question
  As a regular user
  I'd like to answer the question
} do
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }

  scenario 'create an answer' do
    visit question_path(question)
    fill_in 'Body', with: answer.body
    click_on 'Answer'

    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content answer.body
  end

  scenario 'make an answer with errors' do
    visit question_path(question)
    click_on 'Answer'

    expect(page).to have_content "Body can't be blank"
  end
end
