class PublishDish < ActiveRecord::Base
  belongs_to :dish
  belongs_to :day_category
  belongs_to :canteen_worker
end
