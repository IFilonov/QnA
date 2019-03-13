require 'rails_helper'

feature 'User can see question with answers', %q{
  In order to choose interesting question
  As a regular user
  I'd like to see all questions
} do
  given(:user) { create(:user) }  
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 5, question: question, user: user) }

  scenario 'see question with answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end

end
