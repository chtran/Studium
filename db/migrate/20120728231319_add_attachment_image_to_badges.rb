class AddAttachmentImageToBadges < ActiveRecord::Migration
  def self.up
    change_table :badges do |t|
      t.has_attached_file :image
    end
  end

  def self.down
    drop_attached_file :badges, :image
  end
end
