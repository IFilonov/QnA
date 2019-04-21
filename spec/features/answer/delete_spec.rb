require 'rails_helper'

feature 'User can delete answer', %q{
  As an authenticated user
  I'd like to delete my answer
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user deletes his answer', js: true do
    sign_in(user)

    visit question_path(question)

    click_on 'Delete answer'

    expect(page).to have_content 'Answer successfully deleted.'
    expect(page).not_to have_content answer.body
  end

  scenario 'Authenticated user could not delete not his answer', js: true do
    sign_in(another_user)

    visit question_path(question)

    expect(page).not_to have_link 'Delete answer'
  end

  scenario 'Unauthenticated user could not delete any answer', js: true do
    visit question_path(question)

    expect(page).not_to have_link 'Delete answer'
  end

  scenario 'Authenticated user deletes his answer files', js: true do
    answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: "rails_helper.rb")
    answer.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: "spec_helper.rb")

    sign_in(user)
    visit question_path(question)

    expect(page).to have_link 'rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb'

    click_on 'Edit answer'

    id = answer.files.first.id
    click_on "del-file#{id}"
    click_on "del-file#{id + 1}"

    click_on 'Save'

    expect(page).to_not have_link 'rails_helper.rb'
    expect(page).to_not have_link 'spec_helper.rb'
  end

  scenario 'Unauthenticated user cannot delete question files', js: true do
    answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: "rails_helper.rb")
    answer.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: "spec_helper.rb")

    visit question_path(question)

    id = answer.files.first.id
    expect(page).to_not have_link "del-file#{id}"
    expect(page).to_not have_link "del-file#{id + 1}"
  end
end
