class RemoveUserIdFromBadges < ActiveRecord::Migration
  def change
    remove_column :badges,:user_id
  end
end
