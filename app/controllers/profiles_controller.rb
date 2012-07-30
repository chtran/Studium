class ProfilesController < ApplicationController
  before_filter :find_user
  before_filter :find_profile
  before_filter :authenticate_update!,only: [:edit,:update]
  before_filter :authenticate_user!,only: [:increase_reputation]

  def show
    gon.user_id = params[:user_id]

    @badges=current_user.badges
  end

  def edit
  end

  def update
    @profile.update_attributes! params[:profile]
    redirect_to user_profile_url(@user),notice: "Profile has been updated."

  rescue
    flash[:alert]="Profile has not been updated."
    render "edit"
  end

  def increase_reputation
    chat_message=ChatMessage.find params[:chat_message_id]
    reputation_increase=params[:reputation_increase]

    if current_user!=@profile.user and !chat_message.users.include?(current_user)
      @profile.reputation+=reputation_increase.to_i
      chat_message.users << current_user
      chat_message.save!
      @profile.save!

      consider_altruist_badge(@profile.user,@profile.reputation)
    end

    redirect_to index_path
  end

  def consider_altruist_badge(user,reputation)
    altruist_badge=BadgeManager.consider_altruist_badges(user,reputation)
  
    if altruist_badge!=nil
      publish_async("presence-rooms", "update_recent_activities", {
        message: "User #{user.name} has received #{altruist_badge.name} badge. Congratulations!"
      })
    end
  end

private
  def find_user
    @user=User.find params[:user_id]

  rescue
    redirect_to index_url,alert: "The user you were looking for could not be found."
  end

  def find_profile
    @profile=@user.profile
  end

  def authenticate_update!
    redirect_to index_url,alert: "You do not have permission to update the profile of that user." unless user_signed_in? and current_user==@user
  end
end
