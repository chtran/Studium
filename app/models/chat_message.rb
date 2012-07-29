class ChatMessage < ActiveRecord::Base
  attr_accessible :content, :owner_id

  has_many :chat_message_likes
  has_many :users,through: :chat_message_likes

  belongs_to :owner,class_name: "User"
end
