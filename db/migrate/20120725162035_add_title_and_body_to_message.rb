class AddTitleAndBodyToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :body, :text
    add_column :messages, :title, :text
  end
end
