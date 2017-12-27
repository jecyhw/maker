class CreateStairLayers < ActiveRecord::Migration
  def change
    create_table :stair_layers do |t|
      t.integer :layer
      t.references :canteen, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
