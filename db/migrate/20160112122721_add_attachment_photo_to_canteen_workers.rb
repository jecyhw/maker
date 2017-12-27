class AddAttachmentPhotoToCanteenWorkers < ActiveRecord::Migration
  def self.up
    change_table :canteen_workers do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :canteen_workers, :photo
  end
end
