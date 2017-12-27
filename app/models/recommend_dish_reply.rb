class RecommendDishReply < ActiveRecord::Base
  belongs_to :canteen
  belongs_to :recommend_dish
end
