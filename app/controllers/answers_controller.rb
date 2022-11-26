# frozen_string_literal: true

# Ответы
class AnswersController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_question!
  before_action :set_answer!, except: :create

  def create
    @answer = @question.answers.build answer_create_params

    if @answer.save
      flash[:success] = t 'answers.create.success'
      redirect_to question_path(@question)
    else
      @question = @question.decorate
      @pagy, @answers = pagy @question.answers.order created_at: :desc
      @answers = @answers.decorate
      render 'questions/show'
    end
  end

  def edit; end

  def update
    if @answer.update answer_update_params
      flash[:success] = t 'answers.update.success'
      redirect_to question_path(@question, anchor: dom_id(@answer))
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy
    flash[:success] = t 'answers.destroy.success'
    redirect_to question_path(@question)
  end

  private

  def set_question!
    @question = Question.find(params[:question_id])
  end

  def set_answer!
    @answer = @question.answers.find(params[:id])
  end

  def answer_create_params
    params.require(:answer).permit(:body).merge(user: current_user)
  end

  def answer_update_params
    params.require(:answer).permit(:body)
  end
end
