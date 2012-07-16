class ChangeDefaultValueForUserExp < ActiveRecord::Migration
  def up
    change_column :users, :exp, :integer, :default => 1400
  end

  def down
  end
end
