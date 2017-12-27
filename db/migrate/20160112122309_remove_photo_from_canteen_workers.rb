class RemovePhotoFromCanteenWorkers < ActiveRecord::Migration
  #rails g migration RemovePhotoFromCanteenWorkers photo:string
  def change
    remove_column :canteen_workers, :photo, :string
  end
end
