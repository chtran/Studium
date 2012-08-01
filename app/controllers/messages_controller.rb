class MessagesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_cache_buster

  
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
      @message = Message.new(:receiver_id => r_id, :sender_id => current_user.id, :body => params[:body], :read => false)
      if @message.save
        @new_message = current_user.sent_messages.first
        publish_async("user_#{r_id}", "message", {
          message_id: @new_message.id,
          body: params[:body],
          sender: current_user.name,
          sender_id: current_user.id,
          image: current_user.profile.image
        })
      else
        notice = "Message could not be sent to " + User.find(r_id).name
      end

    end
    if !notice then notice = "Message(s) sent" end
    redirect_to messages_path, notice:  notice


  end

  def show
    @message = Message.find(params[:id])
    @message.update_attributes(:read => true)
  end

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

end
