class WallpostsController < ApplicationController

  def create_wallpost
#    @wallpost = Wallpost.new(params[:wallpost])
    receiver_id = params[:receiver_id]
    sender_id   = params[:sender_id]
    content     = params[:content].to_s
    profile_id  = User.find(receiver_id).profile.id.to_s

    new_wallpost = {
      receiver_id: receiver_id,
      sender_id: sender_id,
      content: content,
      profile_id: profile_id
    }

    w = Wallpost.new(new_wallpost)
    w.save
  end


end
