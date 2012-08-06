module MessagesHelper
  def partial_view_for_message(message)
    message.sender==current_user ? "message_left" : "message_right"
  end
end
