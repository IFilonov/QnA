class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files
  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  default_scope -> { order('best desc, id') }
  scope :best, -> { where(best: true) }

  def best!
    ActiveRecord::Base.transaction do
      question.answers.best.update_all(best: false)
      update!(best: true)
      user.award!(question.reward) if question.reward.present?
    end
  end
end
