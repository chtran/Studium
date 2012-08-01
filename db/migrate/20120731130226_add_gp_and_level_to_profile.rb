class AddGpAndLevelToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :gp, :integer, default: 0
    add_column :profiles, :level, :integer, default: 1
  end
end
