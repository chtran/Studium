class AddStatusToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :status, :string
  end
end
