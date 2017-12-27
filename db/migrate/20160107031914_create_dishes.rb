class CreateDishes < ActiveRecord::Migration
  def change
    create_table :dishes do |t|
      t.string :name
      t.decimal :price, precision: 10, scale: 2
      t.datetime :add_time
      t.text :description
      t.string :photo
      t.references :dish_type, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
