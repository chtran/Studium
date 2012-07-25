class Friendship < ActiveRecord::Base
  attr_accessible :friend_id, :user_id
  def self.create_friendship(user,friend)
    if Friendship.where(user_id: user.id, friend_id: friend.id).count==0
      Friendship.create({user_id: user.id, friend_id: friend.id})
    end
    if Friendship.where(user_id: friend.id, friend_id: user.id).count==0
      Friendship.create({user_id: friend.id, friend_id: user.id})
    end
  end

end
