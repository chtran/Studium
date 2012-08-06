class RemoveProfileIdFromWallPost < ActiveRecord::Migration
  def up
    remove_column :wallposts, :profile_id
  end

  def down
  end
end
