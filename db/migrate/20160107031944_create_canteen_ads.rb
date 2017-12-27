class CreateCanteenAds < ActiveRecord::Migration
  def change
    create_table :canteen_ads do |t|
      t.string :name
      t.text :content
      t.datetime :date
      t.references :canteen_worker, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
