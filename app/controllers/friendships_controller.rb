class FriendshipsController < ApplicationController
  def add
    Friendship.find_or_create_by_user_id_and_friend_id({
      user_id: current_user.id,
      friend_id: params[:friend_id]
    })
    render json: {
      name: User.find(params[:friend_id]).name
    }
  end

  def pending_requests
    render partial: "pending_requests", locals: { requesters: current_user.requesters}
  end

end
