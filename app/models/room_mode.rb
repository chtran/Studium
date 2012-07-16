class RoomMode < ActiveRecord::Base
  attr_accessible :title
  has_many :rooms

  def questions_for_room_mode(room_mode,users)
    []
  end
end
