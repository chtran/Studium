class CreateBadgeManagers < ActiveRecord::Migration
  def change
    create_table :badge_managers do |t|
      t.integer :user_id
      t.integer :correct_qiar_counter,default: 0
      t.integer :question_counter,default: 0
      t.integer :perfect_replay_counter,default: 0
      t.integer :math_q_counter,default: 0
      t.integer :math_qiar_counter,default: 0
      t.integer :wr_q_counter,default: 0
      t.integer :wr_qiar_counter,default: 0
      t.integer :cr_q_counter,default: 0
      t.integer :cr_qiar_counter,default: 0

      t.timestamps
    end
  end
end
