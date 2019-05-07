class Reward < ApplicationRecord
  belongs_to :question
  has_one_attached :image_file, dependent: :destroy

  validates :name, presence: true
end
