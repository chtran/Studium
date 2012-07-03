class RoomsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @rooms = Room.all
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(params[:room])
    if @room.save
      redirect_to room_join_path(:room_id => @room.id)
    else
      redirect_to rooms_path, alert: "Error creating room"
    end
  end

  def join
    @room = Room.find(params[:room_id])
    if (@room.questions.empty?)
      generate_questions(@room)
    end
    choose_question(@room)
  end

  def choose
    @choice_id = params[:choice_id]
    @room = Room.find(params[:room_id])
    new_history_item = History.new({user_id: current_user.id, room_id: @room.id, question_id: @room.question.id, choice_id: @choice_id})
    new_history_item.save
    @next_question = choose_question(@room)
    respond_to do |format|
      format.json do
        render :json => @next_question
      end
    end
  end
  
  def show_question
    @question = Question.find(params[:question_id])
    render :partial => "show_question"
  end

  # Generate new questions for the input room when it run out of buffer questions
  def generate_questions(room)
    # Temporarily assign all the questions to each room
    room.questions = Question.all
    room.save
  end

  # Choose new question from buffer questions
  def choose_question(room)
    # Temporarily choose a random question from buffer
    this_questions = room.questions
    r = Random.new
    next_question = this_questions[r.rand(0..this_questions.length-1)]
    # Delete the next_question from the buffer
    #QuestionsBuffer
    #  .where({room_id: room.id, question_id:next_question.id})
    #  .destroy_all
    
    room.question = next_question
    room.save
    return next_question
  end
end
