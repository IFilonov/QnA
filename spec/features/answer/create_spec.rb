require 'rails_helper'

feature 'User can create answer', %q{
  In order to get answer on a question
  As an authenticated user
  I'd like to answer the question
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'create an answer', js: true do
    sign_in(user)

    visit question_path(question)
    fill_in 'Body', with: "Answer body"
    click_on 'Answer'

    expect(page).to have_content "Answer body"
  end

  scenario 'Authenticated user can answer with many attached file', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: "Answer body"
    attach_file 'answer-file-field', ["#{Rails.root}/spec/rails_helper.rb","#{Rails.root}/spec/spec_helper.rb"]

    click_on 'Answer'
    expect(page).to have_link 'rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb'
  end


  scenario 'make an answer with errors', js: true do
    sign_in(user)

    visit question_path(question)

    click_on 'Answer'

    expect(page).to have_content "Body can't be blank"
  end

  scenario 'make an answer by unauthenticated user with errors', js: true do
    visit question_path(question)

    expect(page).not_to have_link "Answer"
  end
end
