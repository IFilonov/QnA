class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :find_question, only: [:show, :edit, :update, :destroy, :delete_file]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def delete_file
    if current_user.author_of?(@question)
        @question.files.attachments.find(params[:file_id]).purge
        @question.reload
    else
      redirect_to @question, notice: 'Only author can delete question files.'
    end
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
    else
      redirect_to @question, notice: 'Only author can edit question'
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Your question successfully deleted'
    else
      redirect_to @question, alert: 'Only author can delete question.'
    end
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :file_id, files:[])
  end
end
