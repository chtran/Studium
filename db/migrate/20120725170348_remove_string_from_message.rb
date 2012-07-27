class RemoveStringFromMessage < ActiveRecord::Migration
  def up
    remove_column :messages, :string
  end

  def down
    add_column :messages, :string, :integer
  end
end
