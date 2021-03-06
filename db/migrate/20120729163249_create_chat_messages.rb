class CreateChatMessages < ActiveRecord::Migration
  def change
    create_table :chat_messages do |t|
      t.text :content
      t.integer :owner_id

      t.timestamps
    end

    create_table :chat_message_like do |t|
      t.integer :chat_message_id
      t.integer :user_id

      t.timestamps
    end

    if column_exists? :profiles,:reputation
      remove_column :profiles,:reputation
    end
    add_column :profiles,:reputation,:integer,default: 0
  end
end
