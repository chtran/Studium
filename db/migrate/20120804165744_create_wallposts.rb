class CreateWallposts < ActiveRecord::Migration
  def change
    create_table :wallposts do |t|
      t.integer :profile_id
      t.integer :sender_id
      t.integer :receiver_id
      t.string :content
      
      t.timestamps
    end
  end
end
