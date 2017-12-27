class CreateDayCategories < ActiveRecord::Migration
  def change
    create_table :day_categories do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
