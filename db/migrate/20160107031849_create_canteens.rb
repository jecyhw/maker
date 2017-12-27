class CreateCanteens < ActiveRecord::Migration
  def change
    create_table :canteens do |t|
      t.string :name
      t.string :photo
      t.references :region, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
