class CreatePublishDishes < ActiveRecord::Migration
  def change
    create_table :publish_dishes do |t|
      t.date :time
      t.text :description
      t.references :dish, index: true, foreign_key: true
      t.references :day_category, index: true, foreign_key: true
      t.references :canteen_worker, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
