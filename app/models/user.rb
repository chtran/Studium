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
  has_many :wallposts, foreign_key: "receiver_id"
  has_and_belongs_to_many :badges

  accepts_nested_attributes_for :profile

  def facebook
    @facebook ||= Koala::Facebook::API.new(oauth_token)
  end

  def status_message
    array = ["Observing", "Answering", "Confirmed", "Ready"]
    return array[self.status]
  end

  def leave_room
    if self.room_id!=nil
      room = self.room
      Pusher["presence-rooms"].trigger_async("leave_room_recent_activities", {
        room_title: room.title,
        user_name: self.name
      })
      self.room = nil
      self.status = 0
      self.save
      room.deactivate if room.users.count==0
    end
  end

  def self.return_hash_data
    self.all.collect do |u| {
      "name" => u.name + '  (' + u.email + ')',
      "id" => u.id
    }
    end
  end

  def user_item
    "#{self.name}"
  end
end
