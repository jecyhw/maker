class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :account
      t.string :password
      t.string :photo
      t.integer :gender

      t.timestamps null: false
    end
  end
end
