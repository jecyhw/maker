class AddNameToCanteenWorkers < ActiveRecord::Migration
  def change
    add_column :canteen_workers, :name, :string
  end
end
