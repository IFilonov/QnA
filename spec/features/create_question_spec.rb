require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As a regular user
  I'd like to ask the question
} do
  given(:question) { create(:question) }

  scenario 'asks a question' do
    visit new_question_path
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    click_on 'Ask'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'asks a question with errors' do
    visit new_question_path
    click_on 'Ask'

    expect(page).to have_content "Title can't be blank"
  end
end
