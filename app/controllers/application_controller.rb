require 'pusher'
Pusher.app_id = Studium::Application.config.pusher_app_id
Pusher.key = Studium::Application.config.pusher_key
Pusher.secret = Studium::Application.config.pusher_secret

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :initialize_gon

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
    @current_controller=controller_name
    @current_action=action_name

    gon.current_controller=@current_controller
    gon.current_action=@current_action
    gon.user_id = current_user.id if signed_in?
  end
end
