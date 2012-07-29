class CreateReputationForExistingUsers < ActiveRecord::Migration
  def change
    Profile.all.each do |profile|
      profile.reputation=Reputation.create! profile_id: profile.id
    end
  end
end
