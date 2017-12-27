require 'net/smtp'
message = <<MESSAGE_END
From: Private Person <me@fromdomain.com>
To: A Test User <test@todomain.com>
Subject: SMTP e-mail test

This is a test e-mail message.
MESSAGE_END

server = 'smtp.qq.com'
mail_from_domain = 'qq.com'
port = 25      # or 25 - double check with your provider
username = '512817467@qq.com'
password = 'ewdtnycltlvrbjga'

smtp = Net::SMTP.new(server, port)
smtp.enable_starttls_auto
smtp.start(server,username,password, :login)
smtp.sendmail(message, '512817467@qq.com', 'liyan815@mails.ucas.ac.cn')


#163
# ActionMailer::Base.smtp_settings = {
#     :address              => 'smtp.163.com',
#     :port                 => 25,
#     :domain               => '163.com',
#     :user_name            => 'm18810982106@163.com',
#     :password             => 'gmqzhpgzvpspjwvb',
#     :authentication       => :login,
#     :enable_starttls_auto => true
# }

# ActionMailer::Base.smtp_settings = {
#     :address              => 'smtp.gmail.com',
#     :port                 => 587,
#     :domain               => 'gmail.com',
#     :user_name            => 'jecyhw@gmail.com',
#     :password             => 'huiwei173500165',
#     :authentication       => :login,
#     :enable_starttls_auto => true
# }

#sina
# ActionMailer::Base.smtp_settings = {
#     :address              => 'smtp.sina.com',
#     :port                 => 25,
#     # :domain               => 'aliyun.com',
#     :user_name            => 'jecyhw@sina.com',
#     :password             => '1029384756',
#     :authentication       => :plain,
#     :enable_starttls_auto => true
# }


# require "openssl"
# require "net/smtp"
# message = <<MESSAGE_END
# From: Private Person <me@fromdomain.com>
# To: A Test User <test@todomain.com>
# Subject: SMTP e-mail test
# This is a test e-mail message.
# MESSAGE_END
#
#
#
#
#
#
# server = 'smtp.gmail.com'
# mail_from_domain = 'gmail.com'
# port = 587     # or 25 - double check with your provider
# username = 'jecyhw@gmail.com'
# password = 'huiwei173500165'
#
# smtp = Net::SMTP.new(server, port)
# smtp.enable_starttls_auto
# smtp.start(server,username,password, :plain)
# smtp.sendmail(message, 'jecyhw@gmail.com', 'yanghuiwei15@mails.ucas.ac.cn')