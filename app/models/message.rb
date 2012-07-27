class Message < ActiveRecord::Base
  
  validates :title, :body, :sender_id, :receiver_id, presence: true 
  attr_accessible :title, :body, :sender_id, :receiver_id

  def mes_valid?
    return self.sender_id != self.receiver_id
  end
end
