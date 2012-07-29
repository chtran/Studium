class AddProfileIdToReputations < ActiveRecord::Migration
  def change
    add_column :reputations, :profile_id, :integer
  end
end
