class RoomsController < ApplicationController
  before_filter :authenticate_user!
  protect_from_forgery

  def index
    @name = current_user.name
    @friends = current_user.friends
    @image = current_user.profile.image
    @top_users = User.joins(:profile).order("gp DESC").limit(5)
    gon.user_id = current_user.id
    @new_room = Room.new
    #current_user.update_attribute(:status,0) unless current_user.status==0
  end

  # Request type: POST
  # Return: the room list
  # Used for dynamically updating the room list
  def room_list
    @rooms = Room.where(:active => true)
    render partial: "room_list"
  end

  def create
    @room = Room.new(params[:room])
    if @room.save
      # See application_controller for publish_async method.
      publish_async("presence-rooms", "rooms_change", {})
      redirect_to room_join_path(@room.id)
    else
      alert=""
      @room.errors.full_messages.each do |msg|
        alert+=msg+"\n"
      end
      redirect_to rooms_path, alert: alert
    end
  end

  def join
    @room = Room.find params[:room_id]
    if @room.active?
      gon.user_id = current_user.id
      gon.room_id = @room.id
      current_user.update_attributes({
        room_id: @room.id,
        status: 0
      })
      gon.observing = (@room.users.count!=1)
      choose_question!(@room) if !@room.question
      publish_async("presence-room_#{@room.id}","users_change", {})
      publish_async("presence-rooms", "update_recent_activities", {
        message: "#{current_user.name} has joined room #{@room.title}"
      })
    else
      redirect_to rooms_path,alert: "The room you were looking for has been deactivated"
    end

  rescue ActiveRecord::RecordNotFound
    redirect_to rooms_path,alert: "The room you were looking for could not be found."
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
  def confirm
    return unless current_user.status==1
    @room = current_user.room
    @current_question = @room.question
    channel="presence-room_#{@room.id}"
    publish_async(channel, "users_change", {})
    if params[:choice_id]
      @choice_id = params[:choice_id]
      new_history_item = History.create({user_id: current_user.id, room_id: @room.id, question_id: @room.question.id, choice_id: @choice_id})
      publish(channel, "update_histories", {
        history_id: new_history_item.id
      })
      # Consider badges
      badges=BadgeManager.awardBadges(current_user,@current_question,Choice.find(@choice_id))
        # If user received some badge(s), post the news
      unless badges.empty?
        badges.each do |badge|
          news="#{current_user.name} has received #{badge.name} badge. Congratulations!"
          publish_async(channel,"update_news",{
            news: news
          })

          publish_async("presence-rooms", "update_recent_activities", {
            message: news
          })

          message=render_to_string partial: "badges/badge_notification",locals: {badge: badge}
          publish_async("user_#{current_user.id}","notification",{
            title: "Got new badge",
            message: message,
            type: "success"
          })

        end
      end
    end
    
    current_user.update_attribute(:status, 2)
    if @room.show_explanation?
      # Update the histories of the room

      # Show explanantion
      publish_async(channel, "show_explanation", {})
    end

    render :text => "OK", :status => "200"
  end
  
  # Request type: POST
  # Input: room_id
  # Effect: change user's status to 3 (Ready). 
  #   If everyone is ready then choose next question and publish_async to /rooms/next_question
  def ready
    return unless current_user.status==2
    @room = current_user.room
    publish_async("presence-room_#{@room.id}","users_change",{})
    current_user.update_attribute(:status, 3)
    if @room.show_next_question?
      if @next_question = choose_question!(@room)
        @room.users.each do |user|
          user.update_attribute(:status, 1)
        end
        question_id = @next_question.id
      else
        question_id = 0
      end
      #Publish next_question
      #If there're questions left, publish question_id
      #Else, publish question_id = 0, it will redirect user out of the room
      publish("presence-room_#{@room.id}","next_question", {
        question_id: question_id
      })
      render :text => "OK", :status => "200"
    end
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
    room = Room.find(params[:room_id])
    publish_async("presence-rooms", "update_recent_activities", {
      message: "#{current_user.name} has left room #{room.title}."
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
  end

  # Input: question_id
  # Return: HTML of that question
  def show_question
    require "parser"
    current_user.update_attribute(:status, 1)
    publish_async("presence-room_#{current_user.room_id}", "users_change", {})
    if !params[:question_id]
      render json: {
        message: "Sorry, we ran out of questions for you"
      }
    else
      @question = Question.find(params[:question_id])

      # Question contents, to be returned to the ajax requestor
      question_choices=render_to_string(@question.choices).html_safe
      question_prompt=@question.prompt.parse(question_id: @question.id,is_passage: false).html_safe
      paragraph=@question.paragraph ? @question.paragraph.content.parse(question_id: @question.id,is_passage: true).html_safe : ""
      question_image_url=@question.image_file_name!=nil ? @question.image.url : ""

      render json: {
        question_image_url: question_image_url,
        question_prompt: question_prompt,
        question_choices: question_choices,
        paragraph: paragraph
      }
    end
  end

  # Request type: POST
  # Input: choice_id
  # Return: HTML of the explanation for the question in the room the user is in
  def show_explanation
    @room = current_user.room
    @question = @room.question
    return if !@room.show_explanation?
    last_choice = current_user.histories.last.choice if !current_user.histories.empty?
    current_user_choice = (last_choice and last_choice.question_id==@question.id) ? last_choice : nil

    puts "User #{current_user.id} chose #{current_user_choice.id if current_user_choice}"
    @choices = @question.choices.collect do |choice| {
      data: choice,
      result: if choice.correct
                "correct"
              elsif current_user_choice and choice.id==current_user_choice.id
                "selected"
              end,
      selected: @room.active_users.all.select {|u| u.histories.last.choice_id == choice.id if !u.histories.empty?}
    }
    end
    messages = {
      correct: "Congratulations! You got the right answer.",
      incorrect: "Sorry, you got the wrong answer. See explanation below.",
      blank: "You didn't select an answer. See explanation below."
    }
    styles = {
      correct: "alert alert-success",
      incorrect: "alert alert-error",
      blank: "alert"
    }
    # If there's a choice_id (user chose a choice) and that choice is correct
    if current_user.status != 0
      #If user didn't select answer
      if current_user_choice==nil
        @change= current_user.lose_to!(@question)
        @message = messages[:blank]
        @style = styles[:blank]
      #If user chose an incorrect answer
      elsif !current_user_choice.correct?
        @change = current_user.lose_to!(@question)
        @message = messages[:incorrect]
        @style = styles[:incorrect]
      else
        @change = current_user.win_to!(@question)
        @message = messages[:correct]
        @style = styles[:correct]
      end
    end
    render partial: "show_explanation"
  end

  # Request type: POST
  # Returns a message to put in a chat box
  def chat_message
    @room=current_user.room

    @chat_message=ChatMessage.create! content: params[:message],owner_id: current_user.id
    chat_message=render_to_string partial: "chat_message/chat_message"

    publish_async("presence-room_#{@room.id}", "chat_message", {
      message: chat_message
    })

    render json: {
      message: chat_message
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
    room.questions = room.room_mode.generate_questions(room)
  end

  # Choose new question from buffer questions
  def choose_question!(room)
    questions = room.questions.empty? ? generate_questions!(room) : room.questions
    # Temporarily choose a random question from buffer
    if questions.empty?
      room.update_attribute(:question_id, nil)
      return false
    end
    next_question = questions.first
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

  def leave_room
    old_room = current_user.room
    if old_room
      current_user.leave_room
      if old_room.show_explanation?
        publish("presence-room_#{old_room.id}", "show_explanation",{})
      elsif old_room.show_next_question?
        if next_question = choose_question!(old_room)
          old_room.users.each do |user|
            user.update_attribute(:status, 1)
          end
          question_id = next_question.id
        else
          question_id = 0
        end

        #Publish next_question
        #If there're questions left, publish question_id
        #Else, publish question_id = 0, it will redirect user out of the room
        publish("presence-room_#{old_room.id}","next_question", {
          question_id: question_id
        })

      end
    end
    render text: "OK", status: "200"
  end

  def search_friend
    @term=params[:term]
    @users=User.joins(:profile).where("lower(first_name) like ? OR lower(last_name) like ?","%#{@term.downcase}%","%#{@term.downcase}%")

    @results=@users.map {|user| {label: render_to_string(partial: "users/user_item",locals: {user: user}),value: user.name}}

    if @results.count>8
      @results=@results.take(8)
      @results << {label: render_to_string(partial: "search_more_results_link"),value: "More Results"}
    end
    render json: @results 
  end

  def search_friend_all_results
    term=params[:term]

    @users=[]
    @users=User.joins(:profile).where("lower(first_name) like ? OR lower(last_name) like ?","%#{term.downcase}%","%#{term.downcase}%") if term
  end
end
