class FriendshipsController < ApplicationController
  def add
    user_id = current_user.id
    friend_id = params[:friend_id]
    Friendship.find_or_create_by_user_id_and_friend_id({
      user_id: current_user.id,
      friend_id: friend_id
    })
    new_activity = RecentActivity.generate("add_friend")
    new_activity.subject = User.find(current_user.id)
    new_activity.object = User.find(friend_id)
    new_activity.save!
    render json: {
      name: User.find(friend_id).name
    }
  end

  def pending_requests
    render partial: "pending_requests", locals: { requesters: current_user.requesters}
  end

end
