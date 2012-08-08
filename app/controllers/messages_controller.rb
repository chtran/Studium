class MessagesController < ApplicationController
  before_filter :authenticate_user!

  before_filter :authenticate_view!,only: [:show]
  
  def index
    gon.user_id = current_user.id
    gon.hash_data = User.return_hash_data
    
    # Create a new message
    @message=Message.new
    gon.user_id = current_user.id

    # Organize messages into groups by users
    @messages=current_user.all_messages.sort_by!(&:created_at)
    messages_by_users_for_messages(@messages,current_user)
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

        # Need to update the following:
        # Update messages in message dropdown (nav bar) for both sender and receiver (and highlighted for receiver) => message_list
        # Update messages in #read for both receiver and sender (left-style for sender and right-style for receiver) => new_message
        # Update messages in #index for both receiver and sender => message_new_chain

        # Updates for receiver
        get_recent_message_list_for_user(@message.receiver)
        message_list=render_to_string partial: "message_list"
        message_new_chain=render_to_string partial: "message_chain_content",locals: {message: @message,user: @message.sender}
        message_item=render_to_string partial: "message_item",locals: {message: @message}
        new_message=render_to_string partial: "message_right",locals: {message: @message,user: current_user}

        @new_message = current_user.sent_messages.first
        publish_async("user_#{r_id}", "message", {
          message_new_chain: message_new_chain,
          new_message: new_message,
          sender_id: @message.sender.id,
          message_list: message_list
        })

        # Receiver's message-notification event
        title="New Message"
        type="notice"
        publish_async("user_#{r_id}","notification",{
          title: title,
          message: message_item,
          type: type
        })

        # Updates for sender (which is the current user)
        get_recent_message_list_for_user(@message.sender)
        message_list=render_to_string partial: "message_list"
        message_new_chain=render_to_string partial: "message_chain_content",locals: {message: @message,user: @message.receiver}
        publish_async("user_#{current_user.id}","message",{
          message_new_chain: message_new_chain,
          receiver_id: @message.receiver.id,
          message_list: message_list
        })

      end

      # Render the new message for sender (for appending in #read) => Left-styled
      render partial: "message_left",locals: {message: @new_message,user: current_user}
    end
  end

  def read
    # Get the last message
    @message = Message.find(params[:message_id])
    @message.update_attributes!(read: true)

    # Find messages in the intersection of the arrays of sender's messages and receiver's messages
    sender_messages=@message.sender.all_messages
    receiver_messages=@message.receiver.all_messages
    @messages=(sender_messages & receiver_messages).sort_by!(&:created_at)

    # Reply
    @reply=Message.new
    @receiver_id=@message.sender==current_user ? @message.receiver.id : @message.sender.id
  end

  def read_all
    @user=User.find params[:user_id]
    @user.all_messages.each do |message|
      message.read=true
      message.save!
    end

    render json: {}
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
