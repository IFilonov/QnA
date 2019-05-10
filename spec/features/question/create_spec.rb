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

  scenario 'Authenticated user asks a question with many attached file' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body

    attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb","#{Rails.root}/spec/spec_helper.rb"]
    click_on 'Ask'

    expect(page).to have_link 'rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb'
  end

  scenario 'ask question with reward' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body

    fill_in 'Reward name', with: 'Reward for best answer'
    attach_file 'image_file', Rails.root.join('app/assets/images/badge.jpg').to_s

    click_on 'Ask'

    expect(page).to have_content 'Reward for best answer'
    expect(page).to have_css("img[src*='badge.jpg']")
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
