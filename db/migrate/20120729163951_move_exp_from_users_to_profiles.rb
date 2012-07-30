class MoveExpFromUsersToProfiles < ActiveRecord::Migration
  def up
    add_column :profiles,:exp,:integer,default: 1400
    remove_column :users,:exp
  end

  def down
    remove_column :profiles,:exp
    add_column :users,:exp,:integer,default: 1400
  end
end
