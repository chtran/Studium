class ChatMessageLike < ActiveRecord::Base
  belongs_to :user
  belongs_to :chat_message
end
