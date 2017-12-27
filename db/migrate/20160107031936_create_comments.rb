class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :ancestor_id
      t.text :description
      t.integer :user_id
      t.datetime :comment_time
      t.references :dish, index: true, foreign_key: true
      t.references :comment, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
