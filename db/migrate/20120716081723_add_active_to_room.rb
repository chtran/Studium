class AddActiveToRoom < ActiveRecord::Migration
  def change
    add_column :rooms, :active, :boolean, :default => true
  end
end
