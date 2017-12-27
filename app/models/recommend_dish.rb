class RecommendDish < ActiveRecord::Base
  belongs_to :student
  belongs_to :granted
end
