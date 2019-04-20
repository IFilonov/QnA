require 'rails_helper'

feature 'Only author can choose best answer', %q{
  As an authenticated user
  I'd like to choose best answer
} do
  given!(:user) { create(:user) }
  given!(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:another_answer) { create(:answer, question: question, user: user) }

  scenario 'An author of question choose best answer', js: true do
    sign_in user
    visit question_path(question)

    within '.answers' do
      click_on "best-link#{answer.id}"

      expect(page).to have_field("best-checkbox#{answer.id}", checked: true)
    end
  end

  scenario 'An author of question could not more then one best answer', js: true do
    sign_in user
    visit question_path(question)

    click_on "best-link#{answer.id}"
    click_on "best-link#{another_answer.id}"

    expect(page).to have_field("best-checkbox#{answer.id}", checked: false)
    expect(page).to have_field("best-checkbox#{another_answer.id}", checked: true)
  end

  scenario 'Unauthenticated user could not choose best answer', js: true do
    visit question_path(question)

    expect(page).not_to have_link "best-link#{answer.id}"
    expect(page).not_to have_field("best-checkbox#{answer.id}", checked: false)
  end

end
