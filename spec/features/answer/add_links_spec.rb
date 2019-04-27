require 'rails_helper'

 feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/IFilonov/7d817a0aa1f1d0a8755135aacf01f72c' }

  scenario 'User adds link when give an answer', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Body', with: 'My answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url
    click_on 'Answer'
    save_and_open_page

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
