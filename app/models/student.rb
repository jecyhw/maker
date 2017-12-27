class Student < ActiveRecord::Base

  validates :password,
            format: { with: /\A(?![0-9]+\z)(?![a-zA-Z]+\z)[0-9A-Za-z]{6,16}\z/, message: '密码必须是数字和字母组合,长度必须6到16位' },
            on: :update

  validates :email,
            presence: { message: '邮箱号不能为空'},
            on: :create

  validates :email,format: { with: /[0-9a-zA-Z]+@(?:|mails.)ucas.ac.cn/, message: '邮箱格式不正确' },
            allow_blank: true,
            # presence: { message: '邮箱号不能为空'},
            on: :create

  validates :name, presence: { message: '姓名不能为空' }, on: :update, allow_nil: true

  has_attached_file :photo,
                    styles: { medium: '400x400>', thumb: '200x200>'},
                    url: '/images/student/:id/:style/:basename.:extension',
                    default_url: '/images/canteen_worker/:style/missing.png'
  # validates_attachment_presence :photo, message: '头像不能为空', on: :update
  validates_attachment_size :photo, less_than: 5.megabytes, message: '图片大小不能超过5M', on: :update, unless: 'photo.nil?'
  validates_attachment_content_type :photo, content_type: %w( image/png image/jpeg ), message: '图片必须为jpeg或者png格式', on: :update, unless: 'photo.nil?'


  validate :email_not_registered, on: :create
  # validate :password_is_valid, on: :update

  before_validation :_before_validation
  before_create :_before_create

  def activation
    UserMailer.account_activation(self).deliver_now
  end

  private
    def password_is_valid
      unless self.password.nil?
        unless self.password =~ /\A(?![0-9]+\z)(?![a-zA-Z]+\z)[0-9A-Za-z]{6,16}\z/
          self.errors.add(:password, '密码必须是数字和字母组合,长度必须6到16位')
        end
      end
    end

    def _before_validation
      unless self.name.nil?
        self.name = self.name.strip
      end
    end

    def _before_create
      self.activation_token = Digest::MD5::hexdigest("#{Time.new}#{self.email}")
    end

    def email_not_registered
      if self.errors.blank?
        student = Student.find_by_email(self.email)
        if student
          if student.account#邮件已注册
            self.errors.add(:email, '该邮件已经注册')
          elsif #注册但未激活,删除
            student.delete
          end
        end
      end
    end
end
