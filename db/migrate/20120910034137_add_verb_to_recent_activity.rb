class AddVerbToRecentActivity < ActiveRecord::Migration
  def change
    add_column :recent_activities, :verb, :string
  end
end
