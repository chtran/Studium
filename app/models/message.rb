class Message < ActiveRecord::Base
  
  validates  :body, :sender_id, :receiver_id, presence: true 
  attr_accessible  :body, :sender_id, :receiver_id, :read

  belongs_to :conversation

  def mes_valid?
    return self.sender_id != self.receiver_id
  end
end
