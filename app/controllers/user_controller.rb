require_relative '../../app/helpers/application_helper'
include ApplicationHelper

class UserController < ApplicationController
  def permitted_params
    params.permit!
  end
  def login
    @operate_type = '用户登陆'
    respond_to do |format|
      if request.request_method =~ /post/i
        account = params[:account]
        password = params[:password]

        if account.blank? && password.blank?
          append_msg(:danger, '用户名和密码不能为空')
        elsif account.blank?
          append_msg(:danger, '用户名不能为空')
        elsif password.blank?
          append_msg(:danger, '密码不能为空')
        else
          student = Student.find_by_account(account)
          @user = nil
          @user_type = nil
          if student
            student = Student.find_by_password(password)
            if student
              @user = student
              @user_type = USER_TYPE[:student]
            else
              append_msg(:danger, '密码填写不正确')
            end
          else
            canteen_worker = CanteenWorker.find_by_account(account)
            if canteen_worker
              canteen_worker = CanteenWorker.find_by_password(password)
              if canteen_worker
                @user = canteen_worker
                grant = canteen_worker.granted
                if grant.table_name == 'all'
                  @user_type = USER_TYPE[:admin]
                else
                  @user_type = USER_TYPE[:canteen_worker]
                end
              else
                append_msg(:danger, '密码填写不正确')
              end
            else
              append_msg(:danger, '用户名填写不正确')
            end
          end
        end
      end

      if @user
        session_set(@user, @user_type)
      end
      format.js {render partial: 'user/login.js.erb', :layout => false}
    end
  end

  def register
    permitted_params
    @operate_type = '用户注册'
    if request.request_method =~ /post/i
      if params[:activate]# 激活 post
        password = params[:password]
        confirm_password = params[:confirm_password]
        if password.blank? && confirm_password.blank?
          append_msg(:danger, '未填写密码')
        else
          if password == confirm_password
            @student = Student.find_by_email(params[:email])
            if @student.update({ password: password, account: params[:email]})
              @user = @student
              @user_type = USER_TYPE[:student]
              session_set(@user, @user_type)#设置session
            else
              append_errors_msg(@student)
            end
          else
            append_msg(:danger, '密码和确认密码不匹配')
          end
        end
        respond_to do |format|
          format.js {render partial: 'user/activation.js.erb', :layout => false}
        end
      else #请求邮箱注册
        begin
          @student = Student.create!(params[:student])
          @student.activation
          # append_msg(:success, '邮件发送成功')
          respond_to do |format|
            format.js {render partial: 'user/send_email_success.js.erb', :layout => false}
          end
        rescue => e
          append_errors_msg(e.record)
          respond_to do |format|
            format.js {render partial: 'template/message_notice.js.erb', :layout => false}
          end
        end
      end
    else
      if params[:email]#账号激活
        @student = Student.find_by(email: params[:email], activation_token: params[:activation_token])
        if @student && Time.new < @student.updated_at + 1.hour #注册时这里通过updated_at属性来判断链接是否有效
          if @student.account
            invalid_page #已经激活,页面失效,避免二次激活
          else
            render 'user/activation.html.erb'
          end
        else
          if @student
            @student.delete
          end
          invalid_page
        end
      else
        @student = Student.new
        respond_to do |format|
          format.js {render partial: 'user/get_register_page.js.erb', :layout => false}
        end
      end
    end
  end

  def password_reset
    @operate_type = '密码重置'
    respond_to do |format|
      if request.request_method =~ /post/i

      else

      end
    end
  end

  def activation
    render 'user/activation.html.erb'
  end

  def logout
    session_delete
  end
end
