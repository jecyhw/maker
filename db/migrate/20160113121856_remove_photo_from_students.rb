class RemovePhotoFromStudents < ActiveRecord::Migration
  def change
    remove_column :students, :photo, :string
  end
end
