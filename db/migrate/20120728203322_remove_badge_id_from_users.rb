class RemoveBadgeIdFromUsers < ActiveRecord::Migration
  def change
    remove_column :users,:badge_id
  end
end
