class AddNameSpaceToRoomMode < ActiveRecord::Migration
  def change
    add_column :room_modes, :namespace, :string
  end
end
