require 'rails_helper'

feature 'Only author can edit his answer', %q{
  As an authenticated user
  I'd like to edit my answer
} do
  given!(:user) { create(:user) }
  given!(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user edit his answer', js: true do
    sign_in user

    visit question_path(question)

    within '.answers' do
      click_on 'Edit answer'
      fill_in 'Your answer', with: "answer edited text"

      click_button "Save"

      expect(page).to have_content "answer edited text"
      expect(page).not_to have_content answer.body
    end
  end

  scenario 'Authenticated user could not edit not his answer', js: true do
    sign_in another_user

    visit question_path(question)

    expect(page).not_to have_link "Edit answer"
  end

  scenario 'Unauthenticated user could not edit any answer', js: true do
    visit question_path(question)

    expect(page).not_to have_link "Edit answer"
  end

  scenario 'Edit an answer with errors', js: true do
    sign_in user

    visit question_path(question)

    within '.answers' do
      click_on 'Edit answer'
      fill_in 'Your answer', with: ""
      click_button "Save"
    end
    expect(page).to have_content "Body can't be blank"
  end
end
