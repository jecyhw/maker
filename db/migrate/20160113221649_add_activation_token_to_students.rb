class AddActivationTokenToStudents < ActiveRecord::Migration
  def change
    add_column :students, :activation_token, :string
  end
end
