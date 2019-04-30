require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/IFilonov/7d817a0aa1f1d0a8755135aacf01f72c' }
  given(:gist_url2) { 'https://gist.github.com/IFilonov/e1b5625045959a88a905ad8d5b9720d8' }
  given(:question) { create(:question, user: user) }

  background do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    click_on 'Add link'

    link_names = all('.link-name')
    link_names.first.fill_in(with: 'My gist')
    link_names.last.fill_in(with: 'My gist2')

    link_urls = all('.link-url')
    link_urls.first.fill_in(with: gist_url)
    link_urls.last.fill_in(with: gist_url2)
  end

  scenario 'User adds link when asks question', js: true do
    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
    expect(page).to have_link 'My gist2', href: gist_url2
  end

  scenario 'User can remove links when asks question', js: true do
    remove_links = all('.remove-link')
    remove_links.first.click
    remove_links.last.click

    click_on 'Ask'

    expect(page).to_not have_content 'My gist'
    expect(page).to_not have_content 'My gist2'
  end
end
