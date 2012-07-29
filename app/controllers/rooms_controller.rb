class RoomsController < ApplicationController
  before_filter :authenticate_user!
  protect_from_forgery

  def index
    @user = current_user
    @name = current_user.name
    @friends = current_user.friends
    @image = current_user.profile.image
    @rank = User.where("exp > (?)", @user["exp"]).count + 1
    @top_users = User.order("exp DESC").limit(5)
    gon.user_id = current_user.id
    @new_room = Room.new
    #current_user.update_attribute(:status,0) unless current_user.status==0
    #current_user.update_attribute(:room_id,0) unless current_user.room_id==0
  end

  # Request type: POST
  # Return: the room list
  # Used for dynamically updating the room list
  def room_list
    @rooms = Room.where(:active => true)
    render partial: "room_list"
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(params[:room])
    if @room.save
      # See application_controller for publish_async method.
      publish_async("presence-rooms", "rooms_change", {})
      redirect_to room_join_path(@room.id)
    else
      redirect_to rooms_path, alert: "Error creating room"
    end
  end

  def join
    @room = Room.find(params[:room_id])
    gon.room_id = @room.id
    current_user.update_attribute(:room_id, @room.id)
    choose_question!(@room) if !@room.question
    publish_async("presence-room_#{@room.id}","users_change", {})
    publish_async("presence-rooms", "enter_room_recent_activities", {
      user_name: current_user.name,
      room_title: @room.title
    
    })
    @reload = (@room.users.count==1).to_s
  end

  # Request type: POST
  # Input params: none
  # Return: HTML of the user list of the room the user is in
  # Used for dynamically updating user list in each room
  def user_list
    @room = current_user.room
    @user_list = @room.users
    render partial: "user_list"
  end
  # Request type: POST
  # Input params: choice_id, room_id
  # Effect: create new history item, choose next question
  # Return: current question's id, next question's id, selected choice's id 
  def choose
    @room = current_user.room
    @current_question = @room.question
    if params[:choice_id]
      @choice_id = params[:choice_id]
      new_history_item = History.create({user_id: current_user.id, room_id: @room.id, question_id: @room.question.id, choice_id: @choice_id})
    end
    current_user.update_attribute(:status, 2)
    @room.save
    publish_async("presence-room_#{@room.id}", "users_change", {})
    if @room.show_explanation?
      channel="presence-room_#{@room.id}"

      # Show explanantion
      publish(channel, "show_explanation", {
        question_id: @current_question.id
      }) 

      # Update the histories of the room
      publish_async(channel, "update_histories", {
        history_id: new_history_item.id
      })

      # Consider badges
      badges=BadgeManager.awardBadges(current_user,@room.question,Choice.find(@choice_id))

      # If user received some badge(s), post the news
      unless badges.empty?
        badges.each do |badge|
          publish_async(channel,"update_news",{
            news: "#{current_user.email} received new badge: #{badge.name}"
          })
        end
      end
    end
    render :text => "OK", :status => "200"
  end
  
  # Request type: POST
  # Input: room_id
  # Effect: change user's status to 3 (Ready). 
  #   If everyone is ready then choose next question and publish_async to /rooms/next_question
  def ready
    @room = current_user.room
    current_user.update_attribute(:status, 3)
    publish_async("presence-room_#{@room.id}","users_change",{})
    if @room.show_next_question?
      if @next_question = choose_question!(@room)
        @room.users.each do |user|
          current_user.update_attribute(:status, 1)
        end
        question_id = @next_question.id
      else
        question_id = 0
      end
      publish("presence-room_#{@room.id}","next_question", {
        question_id: question_id
      })
    end
    render :text => "OK", :status => "200"
  end

  def invite
    publish_async("user_#{params[:user_id]}", "invite", {
      user_id: current_user.id,
      user_name: current_user.name,
      room_id: current_user.room_id
    })
    render text: "OK", status: "200"
  end

  # Request type: GET
  # User quiting the room
  # Note: this is different from kick since it's user clicking the quit button, not closing the window. It's called by the user himself
  def review
    #room = current_user.room
    room = Room.find(46)
    publish_async("presence-rooms", "leave_room_recent_activities", {
      room_title: room.title,
      user_name: current_user.name
    })
    histories = current_user.histories
                                .where(room_id: room.id)
                                .joins(:choice)
                                .includes(:question)
    @questions = histories.collect do |h| {
        id: h.question_id,
        prompt: h.question.prompt,
        paragraph: h.question.paragraph,
        choices: h.question.choices.collect do |c| {
          data: c,
          result: if h.question.correct_choice_ids.include? c.id
                    "correct"
                  elsif c.id==h.choice_id
                    "selected"
                  end
          }
        end
      }
    end

    current_user.update_attributes({room_id: 0, status: 0})
  end

  # Request type: POST
  # Other users kicking some user (because he closed his window)
  # Effect: Kick the user from the room (set room_id and status to 0)
  #         Publish users_change event
  def kick
    user = User.find(params[:user_id])
    room = Room.find(params[:room_id])
    user.update_attributes({room_id: 0, status: 0})
    publish_async("presence-room_#{room.id}", "users_change", {})
    publish_async("presence-rooms", "leave_room_recent_activities", {
      room_title: room.title,
      user_name: user.name
    })
    render :text => "Kicked", :status => '200'
  end

  # Input: question_id
  # Return: HTML of that question
  def show_question
    require "parser"
    current_user.update_attribute(:status, 1)
    publish_async("presence-room_#{current_user.room_id}", "users_change", {})
    if params[:question_id]=="0"
      render json: {
        message: "Sorry, we ran out of questions for you"
      }
    else
      @question = Question.find(params[:question_id])
      question_choices=render_to_string(@question.choices).html_safe

      render json: {
        question_prompt: @question.prompt.parse(question_id: @question.id,is_passage: false).html_safe,
        question_choices: question_choices,
        paragraph: @question.paragraph ? @question.paragraph.content.parse(question_id: @question.id,is_passage: true).html_safe : ""
      }
    end
  end

  # Request type: POST
  # Input: choice_id
  # Return: HTML of the explanation for the question in the room the user is in
  def show_explanation
    @room = current_user.room
    return if !@room.show_explanation?
    @question = @room.question
    messages = {
      correct: "Congratulations! You got the right answer.",
      incorrect: "Sorry, you got the wrong answer. See explanation below."
    }
    styles = {
      correct: "alert alert-success",
      incorrect: "alert alert-error"
    }
    # If there's a choice_id (user chose a choice) and that choice is correct
    if params[:choice_id] and Choice.find(params[:choice_id]).correct?
      @change = current_user.win_to!(@question)
      @message = messages[:correct] + " You won "+@change.to_s+" exp!"
      @style = styles[:correct]
    # If there's no choice_id (user hasn't chosen a choice) or the chosen choice is incorrect
    else
      @change = current_user.lose_to!(@question)
      @message = messages[:incorrect] + " You lost "+@change.to_s+" exp."
      @style = styles[:incorrect]
    end
    render :partial => "show_explanation"
  end

  # Request type: POST
  # Returns a message to put in a chat box
  def chat_message
    @room=current_user.room
    message=current_user.email+": "+ params[:message]
    publish_async("presence-room_#{@room.id}","chat_message", {
      message: message
    })

    render json: {
      message: message
    }
  end

  # Request type: POST
  # Input: room_id
  # Return HTML of the individual room item to be shown on rooms#index (Used for real-time room list)
  def show_new_room_item
    room = Room.find(params[:room_id])
    render :partial => "room_item", :locals => {room: room}
  end
  # Generate new questions for the input room when it run out of buffer questions
  def generate_questions!(room)
    room_questions = room.room_mode.generate_questions(room)
    room.questions = room_questions.all
    return room_questions.empty? ? false : room_questions
  end

  # Choose new question from buffer questions
  def choose_question!(room)
    questions = room.questions.empty? ? generate_questions!(room) : room.questions
    # Temporarily choose a random question from buffer
    if !questions
      room.update_attribute(:question_id, 0)
      return false
    end
    next_question = questions.order('RANDOM()').first
    # Delete the next_question from the buffer
    QuestionsBuffer
      .where({room_id: room.id, question_id:next_question.id})
      .destroy_all
    
    room.question = next_question
    room.save
    return next_question
  end

  def show_histories
    @room=Room.find params[:room_id]
    render @room.histories
  end
end
