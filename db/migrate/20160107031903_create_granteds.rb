class CreateGranteds < ActiveRecord::Migration
  def change
    create_table :granteds do |t|
      t.integer :grade
      t.string :table_name
      t.string :alias

      t.timestamps null: false
    end
  end
end
