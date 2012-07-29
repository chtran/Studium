class MessagesController < ApplicationController
  before_filter :authenticate_user!
  def index

  
    @user = current_user
    @name = current_user.name
    @friends = current_user.friends
    @image = current_user.profile.image
    @rank = User.where("exp > (?)", @user["exp"]).count + 1


    @top_users = User.order("exp DESC").limit(5)
    gon.user_id = current_user.id
    @new_room = Room.new
    
    gon.hash_data = User.return_hash_data
    
    @message = Message.new
    @received_messages = current_user.received_messages
    gon.user_id = current_user.id
  end

  def create
    params[:message][:receiver_id] = params[:message][:receiver_id].to_i
    params[:message][:sender_id] = current_user.id
    @message = Message.new(params[:message])
    @params = params
    if @message.mes_valid?
      if @message.save
        notice = "Message sent"
      else
        notice = "Message could not be sent"
      end
      @new_message = current_user.sent_messages.first
      publish_async("user_#{params[:message][:receiver_id]}", "message", {
        message_id: @new_message.id,
        body: params[:message][:body],
        sender: current_user.name,
        sender_id: current_user.id,
        image: current_user.profile.image
      })

      redirect_to messages_path, notice:  notice
    else
        redirect_to messages_path, notice: "Sender and Receiver could not be the same"
    end

  end

  def show
    @user = current_user
    @name = current_user.name
    @friends = current_user.friends
    @image = current_user.profile.image
    @rank = User.where("exp > (?)", @user["exp"]).count + 1
    @top_users = User.order("exp DESC").limit(5)
    gon.user_id = current_user.id
    @new_room = Room.new
    
    @message = Message.find(params[:id])
  end

  def send_message
    @params = params
  end

end
