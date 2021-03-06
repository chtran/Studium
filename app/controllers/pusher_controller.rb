class PusherController < ApplicationController
  protect_from_forgery :except => :auth
  def auth
    if current_user
      data = Pusher[params[:channel_name]].authenticate(params[:socket_id], {
        user_id: current_user.id,
        user_info: {
          name: current_user.name,
          email: current_user.email
        }
      })
      render :json => data
    else
      render :text => "Forbidden", :status => '403'
    end
  end

  def webhook
    webhook = Pusher::WebHook.new(request)
    if webhook.valid?
      webhook.events.each do |event|
        # If the channel is a rooms#join's channel
        puts event["channel"]
        if event["channel"].match /^presence-room_(\d+)$/
          room_id = $1.to_i
          case event["name"]
          when 'channel_vacated'
            room = Room.find(room_id)
            room.deactivate
            room.users.each do |u|
              u.leave_room
            end
            publish_async("presence-rooms", "rooms_change", {})
            puts "Deactivated room #{room_id}"
          end
        end

        if event["channel"].match /^user_(\d+)$/
          user_id = $1.to_i
          case event["name"]
          when 'channel_occupied'
          when 'channel_vacated'
            user = User.find(user_id)
            user.leave_room
          end
        end

      end
      render text: 'ok'
    else
      render text: 'invalid', status: 401
    end
  end
end
