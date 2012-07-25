class Room < ActiveRecord::Base
  belongs_to :question
  belongs_to :room_mode
  has_many :questions_buffers
  has_many :questions, :through => :questions_buffers
  has_many :users
  has_many :histories
  validates :room_mode_id, :presence => true

  # Input: a number indicating some status
  # Return: true if every user in the room has the given status, false otherwise
  def owner
    #owner_array returns an array of 2 elements, the first one is the user_id, second one is number of questions answered in the room
    #if there's no user in the room, in returns []
    owner_array = History.where(
      room_id: self.id, 
      user_id: self.users.collect {|u| u.id}
    ).group(:user_id).count.max
    return User.find(owner_array[0]) if owner_array
  end

  def status_checker(i)
    self.users
        .select(:status)
        .where(:status => [1,2,3])
        .map {|u| u.status==i}
        .inject {|b,a| b and a}
  end
    
  # Return: true if the room is ready to show explanation, false otherwise
  def show_explanation?
    status_checker(2) #Show explanation when everyone is "confirmed" or status==2
  end
    
  def show_next_question?
    status_checker(3) #Show next question when everyone is "ready" or status==3
  end

  def mastered_questions
    return users.collect { |u| u.mastered_questions } 
                .inject { |this,that| this & that }
  end

end
