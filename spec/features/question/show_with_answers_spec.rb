require 'rails_helper'

feature 'User can see question with answers', %q{
  In order to choose interesting question
  As a regular user
  I'd like to see all questions
} do
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 5, question: question) }

  scenario 'see question with answers' do
    visit question_path(question)
    save_and_open_page
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end

end
