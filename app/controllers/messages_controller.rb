class MessagesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @top_users = User.order("exp DESC").limit(5)
    gon.user_id = current_user.id
    @new_room = Room.new
    
    gon.hash_data = User.return_hash_data
    
    @message = Message.new
    @received_messages = current_user.received_messages
    gon.user_id = current_user.id
  end

  def create
    receiver_id = params[:receiver_id] 
    receiver_id = receiver_id.split(',')

    receiver_id.each do |r_id|
      r_id = r_id.to_i
      @message = Message.new params[:message]
      @message.sender_id=current_user.id
      @message.receiver_id=r_id

      if @message.save
        @new_message = current_user.sent_messages.first
        publish_async("user_#{r_id}", "message", {
          message_id: @new_message.id,
          body: @message.body,
          sender: current_user.name,
          sender_id: current_user.id,
          image: current_user.profile.image
        })
      else
        alert = "Message could not be sent to " + User.find(r_id).name
        redirect_to messages_path, alert: alert
      end

    end

    redirect_to messages_path, notice: "Message(s) sent"
  end

  def show
    @top_users = User.order("exp DESC").limit(5)
    gon.user_id = current_user.id
    @new_room = Room.new
    
    @message = Message.find(params[:id])
  end
end
