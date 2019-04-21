require 'rails_helper'

feature 'User can delete question', %q{
  As an authenticated user
  I'd like to delete user question
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Authenticated user deletes his question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content 'Your question successfully deleted'
    expect(page).not_to have_content question.title
    expect(page).not_to have_content question.body
  end

  scenario 'Authenticated user deletes not his question with errors' do
    sign_in(another_user)
    visit question_path(question)

    expect(page).not_to have_link 'Delete question'
  end

  scenario 'Unauthenticated user deletes any question with errors' do
    visit question_path(question)

    expect(page).not_to have_link 'Delete question'
  end

  scenario 'Authenticated user deletes his question files', js: true do
    question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: "rails_helper.rb")
    question.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: "spec_helper.rb")

    sign_in(user)
    visit question_path(question)

    expect(page).to have_link 'rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb'

    click_on 'Edit'

    id = question.files.first.id
    click_on "del-file#{id}"
    click_on "del-file#{id + 1}"

    click_on 'Save'
    expect(page).to_not have_link 'rails_helper.rb'
    expect(page).to_not have_link 'spec_helper.rb'
  end

  scenario 'Unauthenticated user cannot delete question files', js: true do
    question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: "rails_helper.rb")
    question.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: "spec_helper.rb")

    visit question_path(question)

    id = question.files.first.id
    expect(page).to_not have_link "del-file#{id}"
    expect(page).to_not have_link "del-file#{id + 1}"
  end
end
