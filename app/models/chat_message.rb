class ChatMessage < ActiveRecord::Base
  attr_accessible :content, :owner_id
end
