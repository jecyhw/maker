class CanteenOnline < ActiveRecord::Base
  belongs_to :canteen
  belongs_to :stair_layer
  belongs_to :day_category
end
