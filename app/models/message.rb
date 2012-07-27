class Message < ActiveRecord::Base
  
  validates :title, :body, :sender_id, :receiver_id, presence: true 
  attr_accessible :title, :body, :sender_id, :receiver_id
end
