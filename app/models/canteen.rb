class Canteen < ActiveRecord::Base
  belongs_to :region
  has_many :stair_layers

  before_validation :_before_validation

  validates :region_id, presence: { message: '未选择食堂所在区域' }, on: :create
  validates :name, presence: { message: '食堂名不能为空' }
  validate :name_presence_uniqueness_in_same_region

  has_attached_file :photo,
                    styles: { medium: '400x400>', thumb: '200x200>'},
                    url: '/images/canteen/:id/:style/:basename.:extension',
                    default_url: '/images/canteen/:style/missing.png'
  validates_attachment_presence :photo, message: '食堂图片不能为空', on: :create
  validates_attachment_size :photo, less_than: 5.megabytes, message: '图片大小不能超过5M', unless: 'photo.nil?'
  validates_attachment_content_type :photo, content_type: %w( image/png image/jpeg ), message: '图片必须为jpeg或者png格式', unless: 'photo.nil?'

  private
    def _before_validation
      self.name = self.name.strip if self.name
    end

    def name_presence_uniqueness_in_same_region
      if self.errors.blank?
        _region = self.region
        if _region && _region.canteens.find_by_name(self.name)
            self.errors.add(:name, "(#{_region.name}) 已经包含: (#{self.name})")
        end
      end
    end
end
