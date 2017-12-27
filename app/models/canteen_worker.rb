class CanteenWorker < ActiveRecord::Base
  belongs_to :granted

  validates :password,
            format: { with: /\A(?![0-9]+\z)(?![a-zA-Z]+\z)[0-9A-Za-z]{6,16}\z/, message: '密码必须是数字和字母组合,长度必须6到16位' },
            on: :update
  validates :account, presence: { message: '员工号不能为空' }, uniqueness: { message: '该工号已经存在' }
  validates :name, presence: { message: '姓名不能为空' }
  # validate :password_is_valid, on: :update

  has_attached_file :photo,
                    styles: { medium: '400x400>', thumb: '200x200>'},
                    url: '/images/canteen_worker/:id/:style/:basename.:extension',
                    default_url: '/images/canteen_worker/:style/missing.png'
  # validates_attachment_presence :photo, message: '头像不能为空', on: :update
  validates_attachment_size :photo, less_than: 5.megabytes, message: '图片大小不能超过5M', unless: 'photo.nil?'
  validates_attachment_content_type :photo, content_type: %w( image/png image/jpeg ), message: '图片必须为jpeg或者png格式', unless: 'photo.nil?'


  before_create :_before_create
  private
    def password_is_valid
      unless self.password.nil?
        unless self.password =~ /\A(?![0-9]+\z)(?![a-zA-Z]+\z)[0-9A-Za-z]{6,16}\z/
          self.errors.add(:password, '密码必须是数字和字母组合,长度必须6到16位')
        end
      end
    end

    def _before_create
      self.gender = self.gender || 0
      self.login_time = Time.new
      self.password = '1q2w3e'
      self.visit_count = 0
      if self.granted_id.blank? #未赋予权限
        self.granted_id = -1
        self.reference_id = -1
      elsif self.granted_id == 1 #管理员权限
        self.reference_id = -1
      end
    end
end

