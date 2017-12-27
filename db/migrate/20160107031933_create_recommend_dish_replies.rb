class CreateRecommendDishReplies < ActiveRecord::Migration
  def change
    create_table :recommend_dish_replies do |t|
      t.integer :accepted
      t.text :reason
      t.references :canteen, index: true, foreign_key: true
      t.references :recommend_dish, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
