require 'rails_helper'

feature 'User can add links when edit answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:any_url) { 'https://www.google.com/' }
  given(:gist_url) { 'https://gist.github.com/IFilonov/4590d07e33fc2984c8cb92e9167590b8' }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:gist_content) { 'Example gist content' }

  background do
    sign_in(user)
    visit question_path(question)

    click_on 'Edit answer'
    within '.answers' do
      2.times { click_on 'Add link' }

      link_names = all('.link-name')
      link_names.first.fill_in(with: 'My link')
      link_names.last.fill_in(with: 'My gist')

      link_urls = all('.link-url')
      link_urls.first.fill_in(with: any_url)
      link_urls.last.fill_in(with: gist_url)
    end
  end

  scenario 'User adds link when edits answer', js: true do
    click_on 'Save'

    expect(page).to have_link 'My link', href: any_url
    expect(page).to have_content gist_content
  end

  scenario 'User can remove links when edits answer', js: true do
    within '.answers' do
      remove_links = all('.remove-link')
      remove_links.first.click
      remove_links.last.click

      click_on 'Save'

      expect(page).to_not have_content 'My link'
      expect(page).to_not have_content gist_content
    end
  end
end
