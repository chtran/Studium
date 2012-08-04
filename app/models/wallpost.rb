class Wallpost < ActiveRecord::Base
  belongs_to :profile

  attr_accessible :receiver_id, :sender_id, :body
end
