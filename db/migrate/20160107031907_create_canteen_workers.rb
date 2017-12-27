class CreateCanteenWorkers < ActiveRecord::Migration
  def change
    create_table :canteen_workers do |t|
      t.string :account
      t.string :password
      t.string :photo
      t.integer :gender
      t.datetime :login_time
      t.integer :visit_count
      t.integer :reference_id
      t.references :granted, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
