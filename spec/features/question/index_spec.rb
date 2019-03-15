require 'rails_helper'

feature 'User can see all questions', %q{
  In order to choose interesting question
  As a regular user
  I'd like to see all questions
} do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 5, user: user) }

  scenario 'see all questions' do
    visit questions_path
    expect(page).to have_content 'All questions'
    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end

end
