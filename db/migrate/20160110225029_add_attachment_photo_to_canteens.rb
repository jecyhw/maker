class AddAttachmentPhotoToCanteens < ActiveRecord::Migration
  #rails generate paperclip canteens photo
  def self.up
    change_table :canteens do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :canteens, :photo
  end
end
