class UserMailer < ApplicationMailer
  # default from: '512817467@qq.com'
  default from: "#{WEB_NAME}管理员"
  layout 'mailer'

  def account_activation(student)
    @student = student
    mail to: student.email, subject: "#{WEB_NAME}账号激活"
  end

  def password_reset(student)
    @student = student
    mail to: student.email, subject: "#{WEB_NAME}账号重设密码"
  end
end
