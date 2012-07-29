class Profile < ActiveRecord::Base
  belongs_to :user
  has_one :reputation

  validates :first_name,:last_name,presence: true

  before_create :create_reputation

  def create_reputation
    self.reputation=Reputation.create! profile_id: self.id
  end
end
