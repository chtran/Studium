class User < ActiveRecord::Base
  # See lib/modules/user/... for modules
  include User::LevelManager
  include User::QuestionBank
  extend User::Authentication
  include User::MessageHelper
  include User::ProfileHelper
  include User::FriendshipHelper

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

  has_and_belongs_to_many :badges

  def facebook
    @facebook ||= Koala::Facebook::API.new(oauth_token)
  end

  def status_message
    array = ["Observing", "Answering", "Confirmed", "Ready"]
    return array[self.status]
  end

  def self.return_hash_data
    self.all.collect do |u| {
      "name" => u.name,
      "id" => u.id
    }
    end
  end
end
