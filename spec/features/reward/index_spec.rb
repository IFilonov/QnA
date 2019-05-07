require 'rails_helper'

feature 'Autentificated user can view the received rewards' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:rewards) { create_list(:reward, 2, question: question) }

  before do
    rewards.each do |reward|
      user.award!(reward)
      reward.image_file.attach(
           io: File.open(Rails.root.join('app/assets/images/badge.jpg').to_s),
           filename: 'badge.jpg'
      )
    end
    sign_in(user)
  end

  scenario 'rewards list' do
    visit rewards_path

    user.rewards.each do |reward|
      expect(page).to have_content reward.question.title
      expect(page).to have_css("img[src*='#{reward.image_file.filename}']")
      expect(page).to have_content reward.name
    end
  end
end
