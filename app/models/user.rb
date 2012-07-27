class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :room_id, :status, :provider, :uid, :oauth_token
  # Status:
  # 0 - not in any room
  # 1 - answering a question
  # 2 - confirmed an answer
  # 3 - reviewing the answer

  belongs_to :room
  has_many :histories,dependent: :destroy
  has_one :profile,dependent: :destroy
  accepts_nested_attributes_for :profile

  def self.find_for_facebook_auth(auth, signed_in_resource=nil)
    user = User.where(provider: auth.provider, uid: auth.uid).first
    if !user
      user = User.create(provider:auth.provider,
                         uid:auth.uid,
                         email: auth.info.email,
                         password: Devise.friendly_token[0,20],
                         oauth_token: auth.credentials.token)
      profile = Profile.new(first_name: auth.info.first_name,
                            last_name: auth.info.last_name,
                            image: auth.info.image,
                            link: auth.info.urls.Facebook)
      profile.user = user
      profile.save
    else
      user.update_attribute(:oauth_token, auth.credentials.token)
      user.profile.update_attributes({
        image: auth.info.image,
        link: auth.info.urls.Facebook
      })
    end
    user
  end

  def facebook
    @facebook ||= Koala::Facebook::API.new(oauth_token)
  end

  def friends
    uids = facebook.get_connections("me","friends").collect {|f| f["id"]}
    User.where("uid IN (?)", uids)
  end

  def name
    self.profile.first_name + " " + self.profile.last_name
  end

  def status_message
    array = ["Observing", "Answering", "Confirmed", "Ready"]
    return array[self.status]
  end

  def expected(question)
    toReturn = {}
    if question.exp
      toReturn[:user] = 1/(1+10**((question.exp-self.exp)/400.0))
      toReturn[:question] = 1/(1+10**((self.exp-question.exp)/400.0))
    end
    return toReturn
  end

  def lose_to!(question)
    expectation = expected(question)
    change = (32*expectation[:user]).to_i
    self.decrement!(:exp, change)
    question.increment!(:exp, change)
    return change
  end

  def win_to!(question)
    expectation = expected(question)
    change = (32*expectation[:question]).to_i
    self.increment!(:exp, change)
    question.decrement!(:exp, change)
    return change
  end

  def mastered_questions
    questions_id = self.histories
                       .joins(:choice)
                       .where(choices: {correct: true})
                       .select("histories.question_id")
                       .uniq
                       .collect(&:question_id)
    return Question.where("id IN (?)", questions_id)
  end

  def failed_questions
    questions_id = self.histories
                       .where("question_id IN (?)", self.answered_questions.collect(&:id))
                       .where("question_id NOT IN (?)", self.mastered_questions.empty? ? "" : self.mastered_questions.collect(&:id)) 
                       .select("histories.question_id")
                       .uniq
                       .collect(&:question_id)
    return Question.where("id IN (?)", questions_id)
  end

  def answered_questions
    questions_id = self.histories
                       .select(:question_id)
                       .uniq
                       .collect(&:question_id)
    return Question.where("id IN (?)", questions_id)
  end

  def sent_messages
    Message.where("sender_id = ?", self.id)
  end

  def received_messages
    Message.where("receiver_id = ?", self.id)
  end

  def messages
    Message.where("sender_id = ? OR receiver_id = ?", self.id, self.id)
  end


end
