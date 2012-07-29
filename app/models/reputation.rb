class Reputation < ActiveRecord::Base
  attr_accessible :value,:profile_id

  has_and_belongs_to_many :users
  belongs_to :profile

  before_save :consider_altruist_badge

  def consider_altruist_badge
    BadgeManager.consider_altruist_badges(self.profile.user,self.value)
  end
end
