class CreateCanteenWindows < ActiveRecord::Migration
  def change
    create_table :canteen_windows do |t|
      t.string :name
      t.references :stair_layer, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
