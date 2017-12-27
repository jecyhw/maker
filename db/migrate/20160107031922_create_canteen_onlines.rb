class CreateCanteenOnlines < ActiveRecord::Migration
  def change
    create_table :canteen_onlines do |t|
      t.time :start_time
      t.time :end_time
      t.references :canteen, index: true, foreign_key: true
      t.references :stair_layer, index: true, foreign_key: true
      t.references :day_category, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
