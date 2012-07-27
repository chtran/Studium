class RenameFriendshipToFriendships < ActiveRecord::Migration
  def up
    rename_table :friendship, :friendships
  end

  def down
    rename_table :friendships, :friendship
  end
end
