class User
  module FriendshipHelper

    def friends
      friend_ids = Friendship.where(user_id: self.id).select(:friend_id)
      User.where(id: friend_ids)
    end

    def import_facebook_friends
      uids = facebook.get_connections("me","friends").collect {|f| f["id"]}
      friends = User.where("uid IN (?)", uids)
      friends.each do |f|
        Friendship.create_friendship(self,f)
      end
    end
  end
end
