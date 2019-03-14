require 'rails_helper'

feature 'User can delete answer', %q{
  As an authenticated user
  I'd like to delete my answer
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user deletes his answer' do
    sign_in(user)

    visit question_path(question)

    click_on 'Delete answer'

    expect(page).to have_content 'Answer successfully deleted.'
    expect(page).not_to have_content answer.body
  end

  scenario 'Authenticated user could not delete not his answer' do
    sign_in(another_user)

    visit question_path(question)

    expect(page).not_to have_content 'Delete answer'
  end

  scenario 'Unauthenticated user could not delete any answer' do
    visit question_path(question)

    expect(page).not_to have_content 'Delete answer'
  end
end
