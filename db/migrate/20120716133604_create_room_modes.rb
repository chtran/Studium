class CreateRoomModes < ActiveRecord::Migration
  def change
    create_table :room_modes do |t|
      t.string :title

      t.timestamps
    end
  end
end
