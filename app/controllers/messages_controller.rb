class MessagesController < ApplicationController

  def index
    @message = Message.new
  end

  def create
    @message = Message.new(params[:message])
    if @message.save
      alert('success')
    else
      alert('failed')
    end

  end

  def send
#    publish_async("user_#{params[:receiver_id]}", "message", {
#      body: params[:body],
#      title: params[:title],
#      sender: current_user.name,
#      sender_id: current_user.id
#    })
  end

end
