class CreateRecommendDishes < ActiveRecord::Migration
  def change
    create_table :recommend_dishes do |t|
      t.string :name
      t.datetime :recommend_time
      t.text :method_reason
      t.string :photo
      t.integer :reference_id
      t.references :student, index: true, foreign_key: true
      t.references :granted, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
