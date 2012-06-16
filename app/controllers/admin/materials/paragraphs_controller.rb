class Admin::Materials::ParagraphsController < Admin::Materials::BaseController
  before_filter :get_question_type_id,only: [:new]

  def new
    respond_to do |format|
      # Render a normal form for HTML request
      format.html {
        @paragraph = Paragraph.new
      }

      # Respond to a json request
      format.json {
      }
    end
  end

  def create
    @paragraph = Paragraph.new(params[:paragraph])
    if @paragraph.save
      redirect_to admin_materials_questions_path, notice: "Question has been created."
    else
      flash[:alert] = "Invalid Question Information. Question has not been created."
      render "new"
    end
  end

private
  def get_question_type_id
    @question_type_id=params[:question_type_id]
  end
end
