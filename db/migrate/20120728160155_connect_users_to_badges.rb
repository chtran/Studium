class ConnectUsersToBadges < ActiveRecord::Migration
  def change
    add_column :users,:badge_id,:integer

    create_table :users_badges, id: false do |t|
      t.integer :user_id
      t.integer :badge_id
    end
  end
end
