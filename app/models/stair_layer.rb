class StairLayer < ActiveRecord::Base
  belongs_to :canteen
  has_many :canteen_windows
  validates :canteen_id, presence: { message: '未选择食堂' }
  validates :layer, presence: { messsage: '楼层号不能为空' }, numericality: { only_integer: true, message: '(%{value})楼层号只能为数字' }
  validate :layer_uniqueness_in_same_canteen

  # validates :canteen_id, presence: { messsage: '楼层号所在食堂不能为空' }

  private
    def layer_uniqueness_in_same_canteen
      if self.errors.blank?
        _canteen = self.canteen
        if _canteen && _canteen.stair_layers.find_by_layer(self.layer)
            self.errors.add(:layer, "(#{_canteen.name}) 已经包含楼层号: (#{self.layer})")
        end
      end
    end
end
