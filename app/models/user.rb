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

  def expected(that)
    toReturn = {}
    if that.exp
      toReturn[:this] = 1/(1+10**((that.exp-self.exp)/400.0))
      toReturn[:that] = 1/(1+10**((self.exp-that.exp)/400.0))
    end
    return toReturn
  end
  def lose_to(question)
    expectation = expected(question)
    self_change = 32*expectation[:this]
    question_change = 32*(1-expectation[:that])
    self.decrement!(:exp, self_change)
    question.increment!(:exp, question_change)
    return self_change.to_i
  end

  def win_to(question)
    expectation = expected(question)
    self_change = 32*(1-expectation[:this])
    question_change = 32*expectation[:that]
    self.increment!(:exp, self_change)
    question.decrement!(:exp, question_change)
    return self_change.to_i
  end

end
