class CreateMessagesBuffers < ActiveRecord::Migration
  def change
    create_table :messages_buffers do |t|
      t.timestamps
    end
  end
end
