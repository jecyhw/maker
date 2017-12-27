class DishVote < ActiveRecord::Base
  belongs_to :student
  belongs_to :publish_dish
end
