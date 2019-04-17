class Answer < ApplicationRecord
    belongs_to :question
    belongs_to :user
    validates :body, presence: true

    default_scope -> { order('best desc, id') }
    scope :best, -> { where best: true }

    def best!
      update!(best: true)
    end

    def erase_bests
      question.answers.best.update_all(best: false)
    end
end
