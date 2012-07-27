class AddIdToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :id, :integer
  end
end
