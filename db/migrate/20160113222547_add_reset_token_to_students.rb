class AddResetTokenToStudents < ActiveRecord::Migration
  def change
    add_column :students, :reset_token, :string
  end
end
