require 'rails_helper'

feature 'User can delete answer', %q{
  As an authenticated user
  I'd like to delete my answer
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user deletes his answer' do

    sign_in(user)

    visit new_question_path
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    click_on 'Ask'

    visit question_path(question)
    fill_in 'Body', with: "Answer body"
    click_on 'Answer'

    visit question_path(question)

    click_on 'Delete answer'

    expect(page).to have_content 'Answer successfully deleted.'
  end

  scenario 'Authenticated user deletes not his answer with errors' do

    sign_in(user)

    visit new_question_path
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    click_on 'Ask'

    visit question_path(question)
    fill_in 'Body', with: "Answer body"
    click_on 'Answer'

    click_on 'Log out'

    sign_in(another_user)

    visit question_path(question)

    click_on 'Delete answer'

    expect(page).to have_content 'Only author can delete answer.'
  end
end
