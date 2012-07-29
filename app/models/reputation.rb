class Reputation < ActiveRecord::Base
  attr_accessible :value,:profile_id

  has_and_belongs_to_many :users
  belongs_to :profile

  before_save :consider_altruist_badge

  def consider_altruist_badge
    altruist_badge=BadgeManager.consider_altruist_badges(self.profile.user,self.value)
  
    if altruist_badge!=nil
      publish_async("presence-rooms", "update_recent_activities", {
        message: "User #{current_user.name} has received #{altruist_badge.name} badge. Congratulations!"
      })
    end
  end
end
