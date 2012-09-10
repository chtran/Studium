class CreateRecentActivities < ActiveRecord::Migration
  def change
    create_table :recent_activities do |t|
      t.integer :subject_id
      t.string :subject_type
      t.integer :object_id
      t.string :object_type

      t.timestamps
    end
  end
end
