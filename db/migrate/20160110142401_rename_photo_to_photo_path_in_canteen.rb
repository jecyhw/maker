class RenamePhotoToPhotoPathInCanteen < ActiveRecord::Migration
  #rails g migration RenamePhotoToPhotoPathFromCanteens
  def change
    rename_column :canteens, :photo, :photo_path
  end
end
