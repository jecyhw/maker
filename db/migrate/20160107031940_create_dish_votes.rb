class CreateDishVotes < ActiveRecord::Migration
  def change
    create_table :dish_votes do |t|
      t.integer :rating
      t.references :student, index: true, foreign_key: true
      t.references :publish_dish, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
