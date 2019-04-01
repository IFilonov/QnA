class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:create]
  before_action :find_answer, only: [:destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    notice = ""
    if current_user.author_of?(@answer)
      @answer.destroy
      notice = 'Answer successfully deleted.'
    else
      notice = 'Only author can delete answer.'
    end

    redirect_to @answer.question, notice: notice
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
