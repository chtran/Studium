class Wallpost < ActiveRecord::Base
  belongs_to :profile
  belongs_to :receiver,class_name: "User"
  belongs_to :sender,class_name: "User"

  attr_accessible :receiver_id, :sender_id, :content, :profile_id
end
