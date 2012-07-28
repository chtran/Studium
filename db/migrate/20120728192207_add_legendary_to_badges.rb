class AddLegendaryToBadges < ActiveRecord::Migration
  def change
    add_column :badges, :legendary, :boolean,default: false
  end
end
