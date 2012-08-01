class MessagesController < ApplicationController
  before_filter :authenticate_user!

  before_filter :authenticate_view!,only: [:show]
  
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
          message_row: render_to_string(@message),
          message_item: render_to_string(partial: "message_item",locals: {message: @message})
        })
      else
        alert = "Message could not be sent to " + User.find(r_id).name
        redirect_to messages_path, alert: alert
      end

    end

    redirect_to messages_path, notice: "Message(s) sent"
  end

  def show
    @message = Message.find(params[:id])
    @message.update_attributes(:read => true)
  end

private
  def authenticate_view!
    @message = Message.find(params[:id])

    # Redirect to index if the current user is not the sender or 
    # receiver of the currently viewed message
    if current_user!=@message.sender and current_user!=@message.receiver
      redirect_to messages_path,alert: "The message you were looking for could not be found."
    end
  end
end
