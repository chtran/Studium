class Wallpost < ActiveRecord::Base
  belongs_to :profile

  attr_accessible :receiver_id, :sender_id, :content, :profile_id
end
