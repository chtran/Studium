class MessagesController < ApplicationController

  def index
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
