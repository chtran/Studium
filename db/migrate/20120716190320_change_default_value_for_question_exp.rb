class ChangeDefaultValueForQuestionExp < ActiveRecord::Migration
  def up
    change_column :questions, :exp, :integer, :default => 1400
  end

  def down
  end
end
