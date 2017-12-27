require_relative '../../app/helpers/application_helper'
include ApplicationHelper
class StudentController < ApplicationController
  before_action :is_logged

  def index
    @method = params[:method]
    if @method
      @operate_type = OPERATE_TYPE[/[^_]+$/.match(@method).to_s.to_sym]
      params.permit!
      eval(@method)
    end
  end


  def modify_password
    if request.request_method =~ /post/i
      #验证密码是否修改
      old_password = params[:old_password]
      new_password = params[:new_password]
      confirm_password = params[:confirm_password]
      if old_password.blank? && new_password.blank? && confirm_password.blank?
        append_msg(:info, '未填写任何信息')
      else
        @student = Student.find(get_user_id)
        if new_password != confirm_password
          append_msg(:danger, '新密码和确认密码不匹配')
        elsif new_password == old_password
          append_msg(:danger, '新密码和旧密码相同')
        elsif @student.password != old_password
          append_msg(:danger, '旧密码不匹配')
        else
          if @student.update({password: new_password})#更新密码
            append_msg(:success, '密码修改成功')
          else
            append_errors_msg(@student)
          end
        end
      end
      respond_to do |format|
        format.js {render partial: 'template/message_notice.js.erb', :layout => false}
      end
    else
      respond_to do |format|
        @student = Student.find(get_user_id)
        return_json(format, 0, (render_as_string 'student/info/modify_password.html.erb', 'layouts/user_modify.html.erb'))
      end
    end
  end

  def modify_basic_info
    if request.request_method =~ /post/i
      @student = Student.find(get_user_id)
      #修改姓名
      name = params[:student][:name]
      gender = params[:student][:gender]

      if @student.name.blank? || @student.name != name
        if @student.update({name: name})
          append_msg(:success, '姓名修改成功')
          @modify_name = @student.name
          session_set_user(@student)
        else
          append_errors_msg(@student)
        end
      end

      #修改性别
      if !gender.blank? && (@student.gender.blank? || @student.gender != gender)
        if @student.update({gender: gender})
          append_msg(:success, '性别修改成功')
        else
          append_msg(:danger, '性别修改失败')
        end
      end

      if flush_length == 0
        append_msg(:info, '未做任何修改')
      end

      respond_to do |format|
        format.js {render partial: 'template/message_notice.js.erb', :layout => false}
      end

    else
      respond_to do |format|
        @student = Student.find(get_user_id)
        return_json(format, 0, (render_as_string 'student/info/modify_basic_info.html.erb', 'layouts/user_modify.html.erb'))
      end
    end
  end

  def modify_photo
    if request.request_method =~ /post/i
      if params[:student].blank?
        append_msg(:info, '未选择头像')
      else
        @student = Student.find(get_user_id)
        if @student.update({ photo: params[:student][:photo]})
          append_msg(:success, '头像修改成功')
          respond_to do |format|
            format.html { render text: { status: 0, result: { content: render_as_string('student/info/modify_photo.html.erb', 'layouts/user_modify.html.erb'), message: render_as_string('template/bs_alert.html.erb')}}.to_json }
          end
          return
        else
          append_errors_msg(@student)
        end
      end
      respond_to do |format|
        format.html { render text: { status: 0, result: render_as_string('template/bs_alert.html.erb')}.to_json }
      end
    else
      @student = Student.find(get_user_id)
      respond_to do |format|
        return_json(format, 0, (render_as_string 'student/info/modify_photo.html.erb', 'layouts/user_modify.html.erb'))
      end
    end
  end

end
