class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:create]
  before_action :find_answer, only: [:destroy, :update, :best]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Answer successfully deleted.'
    else
      flash[:notice] = 'Only author can delete answer.'
      redirect_to @answer.question
    end
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
    else
      flash[:notice] = 'Only author can edit answer.'
      redirect_to @answer.question
    end
  end

  def best
    best = @answer.best
    @answer.erase_bests
    @answer.best! if !best
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
