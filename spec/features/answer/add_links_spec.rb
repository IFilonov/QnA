require 'rails_helper'

 feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:any_url) { 'https://www.google.com/' }
  given(:gist_url) { 'https://gist.github.com/IFilonov/4590d07e33fc2984c8cb92e9167590b8' }
  given(:bad_url) { 'any url' }
  given!(:gist_content) { 'Example gist content' }

  background do
    sign_in(user)
    visit question_path(question)

    within '.new_answer' do
      fill_in 'Body', with: 'text text text'

      click_on 'Add link'

      link_names = all('.link-name')
      link_names.first.fill_in(with: 'My link')
      link_names.last.fill_in(with: 'My gist')

      link_urls = all('.link-url')
      link_urls.first.fill_in(with: any_url)
      link_urls.last.fill_in(with: gist_url)
    end
  end

  scenario 'User adds links when give an answer', js: true do
    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'My link', href: any_url
      expect(page).to have_content gist_content
    end
  end

  scenario 'User can remove links when give an answer', js: true do
    within '.new_answer' do
      remove_links = all('.remove-link')
      remove_links.first.click
      remove_links.last.click

      expect(page).to_not have_content 'My link'
      expect(page).to_not have_content gist_content
    end
  end

  scenario 'User cannot adds bad link', js: true do
    within '.new_answer' do
      link_names = all('.link-name')
      link_names.first.fill_in(with: 'Bad url')
      link_urls = all('.link-url')
      link_urls.first.fill_in(with: bad_url)
    end

    click_on 'Answer'

    expect(page).to have_content 'Links url invalid format'
  end
end
