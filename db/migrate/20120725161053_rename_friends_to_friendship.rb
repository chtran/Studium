class RenameFriendsToFriendship < ActiveRecord::Migration
  def up
    rename_table :friends, :friendship
  end

  def down
    rename_table :friendship, :friends
  end
end
