class QuestionTypesController < ApplicationController
  before_filter :authenticate_admin!
  


  def dynamic_question_types
    @question_types=QuestionType.order :type_name
  end

  def new 
    @question_types = QuestionType.new
  end

  def create
    @question_types = QuestionType.create(params[:question_types])
    if @question_types.save 
      redirect_to question_types_path, notice: 'Question Type has been created'

    end

  end

  def index
    @question_types = QuestionType.all
  end

end
