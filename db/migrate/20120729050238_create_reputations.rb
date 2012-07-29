class CreateReputations < ActiveRecord::Migration
  def change
    create_table :reputations do |t|
      t.integer :value,default: 0

      t.timestamps
    end

    create_table :reputations_users,index: false do |t|
      t.integer :reputation_id
      t.integer :user_id
    end

    remove_column :profiles,:reputation
  end
end
