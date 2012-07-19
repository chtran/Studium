class AddRoomModeIdToRoom < ActiveRecord::Migration
  def change
    add_column :rooms, :room_mode_id, :integer
  end
end
