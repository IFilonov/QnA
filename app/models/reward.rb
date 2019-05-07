class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true
  has_one_attached :image_file, dependent: :destroy

  validates :name, :image_file, presence: true
end
