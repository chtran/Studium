class AddReputationToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :reputation, :integer,default: 0
  end
end
