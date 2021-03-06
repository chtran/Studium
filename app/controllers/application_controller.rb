require 'pusher'
Pusher.app_id = Studium::Application.config.pusher_app_id
Pusher.key = Studium::Application.config.pusher_key
Pusher.secret = Studium::Application.config.pusher_secret

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :initialize_gon
  before_filter :get_recent_message_list

  def pusher_key
    render :text => Pusher.key
  end
private

  def authenticate_admin!
    redirect_to index_url,alert: "The page you were looking for could not be found." unless user_signed_in? and current_user.admin?
  end

  def authenticate_user!
    redirect_to index_url,alert: "You have to sign in" unless user_signed_in?
  end

  # Publish to a channel with the event and data
  def publish(channel, event, data)
    Pusher[channel].trigger(event,data)
  end

  def publish_async(channel, event, data)
    Pusher[channel].trigger_async(event,data)
  end

  def initialize_gon
    gon.current_controller=controller_name
    gon.current_action=action_name
    gon.user_id = current_user.id if signed_in?
    gon.pusher_key = Pusher.key
  end

  def messages_by_users_for_messages(messages,receiver)
    @messages_by_users={}
    @unread_message=false

    messages.each do |message|
      @unread_message=true unless message.read?
      gon.read_all_mes_url=read_all_messages_url
      sender=message.sender==receiver ? message.receiver : message.sender
      messages=@messages_by_users[sender] || []
      messages << message
      @messages_by_users[sender]=messages 
    end
  end

  def get_recent_message_list
    get_recent_message_list_for_user(current_user) if signed_in?
  end

  def get_recent_message_list_for_user(user)
    @messages=user.all_messages.sort_by! &:created_at
    messages_by_users_for_messages(@messages,user)
  end
end
