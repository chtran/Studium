class User
  module MessageHelper
    def sent_messages
      Message.where("sender_id = ?", self.id).order("created_at DESC")
    end

    def received_messages
      Message.where("receiver_id = ?", self.id).order("created_at DESC")
    end

    def all_messages
      Message.where("sender_id = ? OR receiver_id = ?", self.id, self.id).order("created_at DESC")
    end
  end
end
