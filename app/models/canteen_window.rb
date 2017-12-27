class CanteenWindow < ActiveRecord::Base
  belongs_to :stair_layer

  validates :stair_layer_id, presence: { message: '未选择楼层号' }
  validates :name, presence: { messsage: '窗口名不能为空' }
  validate :name_uniqueness_in_same_stair_layer

  private
  def name_uniqueness_in_same_stair_layer
    if self.errors.blank?
      _stair_layer = self.stair_layer
      if _stair_layer && _stair_layer.canteen_windows.find_by_name(self.name)
          self.errors.add(:name, "楼层号(#{_stair_layer.layer}) 已经包含: (#{self.name})")
      end
    end
  end

end
