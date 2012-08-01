class Message < ActiveRecord::Base
  
  validates  :body, :sender_id, :receiver_id, presence: true 
  attr_accessible  :body, :sender_id, :receiver_id, :read

  belongs_to :conversation
  belongs_to :sender,class_name: "User"
  belongs_to :receiver,class_name: "User"

  def mes_valid?
    return self.sender_id != self.receiver_id
  end
end
