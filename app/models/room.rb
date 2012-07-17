class Room < ActiveRecord::Base
  belongs_to :question
  has_many :questions_buffers
  has_many :questions, :through => :questions_buffers
  has_many :users
  has_many :histories

  # Input: a number indicating some status
  # Return: true if every user in the room has the given status, false otherwise
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
end
