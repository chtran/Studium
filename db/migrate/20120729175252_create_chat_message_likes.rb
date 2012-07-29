class CreateChatMessageLikes < ActiveRecord::Migration
  def change
    drop_table :chat_message_like

    create_table :chat_message_likes do |t|
      t.integer :chat_message_id
      t.integer :user_id

      t.timestamps
    end
  end
end
