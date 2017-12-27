module ApplicationHelper
  def full_title(title)
    full_title = WEB_NAME
    full_title = full_title + '-' + title unless title.blank?
    return full_title
  end

  def flush_length
    length = 0
    flash.each do
      length += 1
    end
    return length
  end

  def append_msg(msg_type, msg)
    if flash.now[msg_type]
      flash.now[msg_type].append(msg)
    else
      flash.now[msg_type] = [msg]
    end
  end

  def append_errors_msg(obj)
    obj.errors.each do |attr, error|
      append_msg(:danger, error);
    end
  end


  #局部布局渲染
  def render_template_tr_show(view, locals)
    render partial: view, layout: 'layouts/tr_show.html.erb', locals: locals
  end

  def render_template_edit_js(format, view)
    format.js {render :partial => view, :layout => 'layouts/edit.js.erb' }
  end

  def render_as_string(view, layout=false, format=[:text], locals={})
    render_to_string partial: view, layout: layout, format: format, locals: locals
  end

  def return_json(format, status, result)
    format.json { render json: {status: status, result: result} }
  end

  #操作和session相关
  def get_user_id
    session[:user_id]
  end

  def get_user_account
    session[:user_account]
  end

  def get_user_name
    session[:user_name]
  end

  def get_user_type
    session[:user_type]
  end

  def is_logged?
    session[:user_id] != nil
  end

  def is_logged
    if session[:user_id].blank?
      if request.xhr?#ajax请求超时
        response.headers['sessionstatus'] = 'timeout'
        render nothing: true
      else
        redirect_to maker_path
      end
    end
  end

  def session_delete
    session.delete(:user_id)
    session.delete(:user_name)
    session.delete(:user_type)
    session.delete(:user_account)
    redirect_to maker_url
  end

  def session_set(user, user_type)
    session[:user_id] = user.id
    session[:user_type] = user_type
    session[:user_name] = user.name
    session[:user_account] = user.account
  end

  def session_set_user(user)
    session[:user_name] = user.name
    session[:user_account] = user.account
  end
end
