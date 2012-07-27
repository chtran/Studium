class RemoveLinkFromProfile < ActiveRecord::Migration
  def up
    remove_column :profiles, :link
  end

  def down
  end
end
