class MessagesController < ApplicationController
  before_filter :authenticate_user!
  def index
  
    @user = current_user.attributes
    @name = current_user.name
    @friends = current_user.friends
    @image = current_user.profile.image
    @rank = User.where("exp > (?)", @user["exp"]).count + 1
    @top_users = User.order("exp DESC").limit(5)
    gon.user_id = current_user.id
    @new_room = Room.new
    

    @message = Message.new
    @received_messages = current_user.received_messages
    gon.user_id = current_user.id
  end

  def create
    params[:message][:receiver_id] = params[:message][:receiver_id].to_i
    params[:message][:sender_id] = current_user.id
    @message = Message.new(params[:message])
    @params = params
    publish_async("user_#{params[:message][:receiver_id]}", "message", {
      body: params[:message][:body],
      title: params[:message][:title],
      sender: current_user.name,
      sender_id: current_user.id,
      image: current_user.profile.image
    })
    if @message.mes_valid?
      if @message.save
        redirect_to messages_path, notice:  "Message sent"
      else
        redirect_to messages_path, notice:  "Message could not be sent"
      end
    else
        redirect_to messages_path, notice: "Sender and Receiver could not be the same"
    end

  end

  def show
    @message = Message.find(params[:id])
  end

  def send_message
    @params = params
  end

end
