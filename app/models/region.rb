class Region < ActiveRecord::Base
  has_many :canteens

  before_validation :_before_validation
  validates :name, presence: { message: '区域名不能为空'}, uniqueness: { message: '(%{value})区域名已存在' }

  private
    def _before_validation
      self.name = self.name.strip if self.name
    end
end
