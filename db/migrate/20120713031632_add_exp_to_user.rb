class AddExpToUser < ActiveRecord::Migration
  def change
    add_column :users, :exp, :integer
  end
end
