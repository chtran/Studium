class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :room_id, :status
  # Status:
  # 0 - not in any room
  # 1 - answering a question
  # 2 - confirmed an answer
  # 3 - reviewing the answer

  belongs_to :room
  has_many :histories,dependent: :destroy
  has_one :profile,dependent: :destroy
  accepts_nested_attributes_for :profile
  def name
    self.profile.first_name + " " + self.profile.last_name
  end

  def expected(question)
    toReturn = {}
    if question.exp
      toReturn[:user] = 1/(1+10**((question.exp-self.exp)/400.0))
      toReturn[:question] = 1/(1+10**((self.exp-question.exp)/400.0))
    end
    return toReturn
  end
  def lose_to(question)
    expectation = expected(question)
    change = (32*expectation[:user]).to_i
    self.decrement!(:exp, change)
    question.increment!(:exp, change)
    return change
  end

  def win_to(question)
    expectation = expected(question)
    change = (32*expectation[:question]).to_i
    self.increment!(:exp, change)
    question.decrement!(:exp, change)
    return change
  end

  def status_message
    array = ["Observing", "Answering", "Confirmed", "Ready"]
    return array[self.status]
  end

end
