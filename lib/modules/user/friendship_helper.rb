class User
  module FriendshipHelper
    def friend_ids
      Friendship.where(user_id: self.id).select(:friend_id).collect {|f| f.friend_id}
    end

    def friends
      User.where(id: self.friend_ids)
    end

    def requester_ids
      Friendship.where(friend_id: self.id).select(:user_id).collect {|f| f.user_id}
    end

    def requesters
      User.where(id: self.requester_ids - self.friend_ids)
    end

    def relationship(user)
      if user.id==self.id or self.friend_ids.include? user.id
        return "friend"
      elsif self.requester_ids.include? user.id
        return "requester"
      else
        return "stranger"
      end
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
