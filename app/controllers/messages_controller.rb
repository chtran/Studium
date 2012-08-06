class MessagesController < ApplicationController
  before_filter :authenticate_user!

  before_filter :authenticate_view!,only: [:show]
  
  def index
    @top_users = User.order("exp DESC").limit(5)
    gon.user_id = current_user.id
    
    gon.hash_data = User.return_hash_data
    
    # Create a new message
    @message = Message.new
    gon.user_id = current_user.id

    # Organize messages into groups by users
    @messages=current_user.all_messages
    @messages_by_users={}
    @messages.each do |message|
      user=message.sender==current_user ? message.receiver : message.sender
      messages=@messages_by_users[user] || []
      messages << message
      @messages_by_users[user]=messages 
    end
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

        message_row=render_to_string(@message)
        message_item=render_to_string(partial: "message_item",locals: {message: @message})
        message_item_list=render_to_string(partial: "message_item_list",locals: {message: @message})

        # Receiver's message-receive event
        @new_message = current_user.sent_messages.first
        publish_async("user_#{r_id}", "message", {
          message_row: message_row,
          message_item: message_item 
        })

        # Receiver's message-notification event
        title="New Message"
        type="notice"
        publish_async("user_#{r_id}","notification",{
          title: title,
          message: message_item,
          type: type
        })
      else
        alert = "Message could not be sent to " + User.find(r_id).name
        redirect_to messages_path, alert: alert
      end

    end

    redirect_to messages_path, notice: "Message(s) sent"
  end

  def read
    # Get the last messag
    @message = Message.find(params[:message_id])
    @message.update_attributes!(read: true)

    # Find messages in the intersection of the arrays of sender's messages and receiver's messages
    sender_messages=@message.sender.all_messages
    receiver_messages=@message.receiver.all_messages
    @messages=(sender_messages & receiver_messages).sort_by!(&:created_at)
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
