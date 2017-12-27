require_relative '../../app/helpers/application_helper'
include ApplicationHelper

class AdminController < ApplicationController
  before_action :is_logged

  def index
    @method = params[:method]
    puts(@method)
    if @method
      @operate_type = OPERATE_TYPE[/[^_]+$/.match(@method).to_s.to_sym]
      params.permit!
      eval(@method)
    end
  end

  def canteen_show
    @canteens = Canteen.all
    respond_to do |format|
      return_json(format, 0, (render_as_string 'admin/canteen/show.html.erb'))
    end
  end

  def canteen_add
    respond_to do |format|
      if request.request_method =~ /post/i
        begin #带文件上传只能返回html
          puts params[:canteen]
          @canteen = Canteen.create!(params[:canteen])
          format.html { render text: { status: 0, result: (render_as_string('admin/canteen/tr.html.erb', 'layouts/tr_show.html.erb', [:text], { canteen: @canteen, tr_style: 'success' })) }.to_json }
        rescue => e
          append_errors_msg(e.record)
          format.html { render text: { status: 1, result: (render_to_string :partial => 'template/bs_alert.html.erb') }.to_json }
        end
      else
        if Region.count > 0
          @canteen = Canteen.new
          return_json(format, 0, (render_as_string 'admin/canteen/edit.html.erb', 'edit_modal.html.erb'))
        else
          append_msg(:warning, '请先创建区域,在添加食堂')
          return_json(format, 1, (render_as_string 'template/bs_alert.html.erb'))
        end
      end
    end
  end

  def canteen_delete
    delete(Canteen, :canteen)
  end

  def canteen_edit
    respond_to do |format|
      if request.request_method =~ /post/i
        @canteen = Canteen.find(params[:id])
        if @canteen.update(params[:canteen])#更新成功
          format.html { render text: { status: 0, result: (render_as_string('admin/canteen/tr.html.erb', 'layouts/tr_show.html.erb', [:text], { canteen: @canteen, tr_style: 'success' })) }.to_json }
        else#更新失败
          append_errors_msg(@canteen)
          format.html { render text: { status: 1, result: (render_to_string :partial => 'template/bs_alert.html.erb') }.to_json }
        end
      else
        @canteen = Canteen.find(params[:id])
        return_json(format, 0, (render_as_string 'admin/canteen/edit.html.erb', 'edit_modal.html.erb'))
      end
    end
  end

  def canteen_window_show
    @canteen_windows = CanteenWindow.all
    respond_to do |format|
      return_json(format, 0, (render_as_string 'admin/canteen_window/show.html.erb'))
    end

  end

  def canteen_window_add
    if request.request_method =~ /post/i
      #验证区域是否选择
      if params[:region_id].blank?
        append_msg(:danger, '未选择区域')
      end

      #验证食堂是否选择
      if params[:canteen_id].blank?
        append_msg(:danger, '未选择食堂')
      end

      params_canteen_window = params[:canteen_window]
      #验证楼层号是否选择
      if params_canteen_window[:stair_layer_id].blank?
        append_msg(:danger, '未选择楼层号')
      end

      if flush_length == 0
        names = Set.new(params_canteen_window[:name].gsub(/\s+/, '').split(SPLITTER))
        if names.length > 0
          @canteen_windows = []
          names.each do |name|
            params_canteen_window[:name] = name
            begin
              temp_canteen_window = CanteenWindow.create!(params_canteen_window)
              @canteen_windows.append(temp_canteen_window)
            rescue => e
              append_errors_msg(e.record)
            end
          end
          if flush_length > 0
            @canteen_windows.each do |canteen_window|
              append_msg(:success, "(#{canteen_window.name})窗口名添加成功")
            end
          end
        else
          append_msg(:danger, '窗口名不能为空')
        end
      end
      respond_to do |format|
        render_template_edit_js(format, 'admin/canteen_window/edit.js.erb')
      end

    else
      respond_to do |format|
        if StairLayer.count > 0
          @canteen_window = CanteenWindow.new
          return_json(format, 0, (render_as_string 'admin/canteen_window/edit.html.erb', 'edit_modal.html.erb'))
        else
          append_msg(:warning, '请先创建食堂的楼层号,在添加窗口')
          return_json(format, 1, (render_as_string 'template/bs_alert.html.erb'))
        end
      end
    end
  end

  def canteen_window_delete
    delete(CanteenWindow, :canteen_window)
  end

  def canteen_window_edit
    if request.request_method =~ /post/i
      @canteen_window = CanteenWindow.find(params[:id])
      unless @canteen_window.update(params[:canteen_window])
        append_errors_msg(@canteen_window)
      end
      respond_to do |format|
        render_template_edit_js(format, 'admin/canteen_window/edit.js.erb')
      end
    else
      @canteen_window = CanteenWindow.find(params[:id])
      respond_to do |format|
        return_json(format, 0, (render_as_string 'admin/canteen_window/edit.html.erb', 'edit_modal.html.erb'))
      end
    end
  end

  def canteen_worker_show
    @canteen_workers = CanteenWorker.where('granted_id != ?', Granted.find_by_grade(0).id)
    respond_to do |format|
      return_json(format, 0, (render_as_string 'admin/canteen_worker/show.html.erb'))
    end
  end

  def canteen_worker_add
    respond_to do |format|
      if request.request_method =~ /post/i
        params_canteen_worker = get_canteen_worker_granted
        begin
          @canteen_worker = CanteenWorker.create!(params_canteen_worker)
        rescue => e
          append_errors_msg(e.record)
        end
        render_template_edit_js(format, 'admin/canteen_worker/edit.js.erb')
      else
        @canteen_worker = CanteenWorker.new
        return_json(format, 0, (render_as_string 'admin/canteen_worker/edit.html.erb', 'edit_modal.html.erb'))
      end
    end
  end
  private
    def get_canteen_worker_granted
      granted_id = -1
      reference_id = -1
      GRANTED.each do |key, value|
        unless params[key].blank?
          granted_id = value
          reference_id = params[key]
        end
      end
      params_canteen_worker = params[:canteen_worker]
      params_canteen_worker[:granted_id] = granted_id
      params_canteen_worker[:reference_id] = reference_id
      params_canteen_worker
    end

  def canteen_worker_delete
    delete(CanteenWorker)
  end

  def canteen_worker_edit
    @canteen_worker = CanteenWorker.find(params[:id])
    respond_to do |format|
      if request.request_method =~ /post/i
        params_canteen_worker = get_canteen_worker_granted
        unless @canteen_worker.update(params_canteen_worker)
          append_errors_msg(@canteen_worker)
        end
        render_template_edit_js(format, 'admin/canteen_worker/edit.js.erb')
      else
        granted_id = @canteen_worker.granted_id

        # OPTIMIZE 工作人员权限编辑的时候,代码需要优化
        if granted_id == GRANTED[:canteen_window] #权限为 窗口
          canteen_window = CanteenWindow.find(@canteen_worker.reference_id)
          #自己
          @canteen_window_id = canteen_window.id
          @canteen_windows = canteen_window.stair_layer.canteen_windows

          #上级
          @region_id = canteen_window.stair_layer.canteen.region_id

          @canteens = canteen_window.stair_layer.canteen.region.canteens
          @canteen_id = canteen_window.stair_layer.canteen_id

          @stair_layers = canteen_window.stair_layer.canteen.stair_layers
          @stair_layer_id = canteen_window.stair_layer_id
        elsif granted_id == GRANTED[:stair_layer] #权限为 楼层
          stair_layer = StairLayer.find(@canteen_worker.reference_id)
          #下一级
          @canteen_windows =stair_layer.canteen_windows

          #自己
          @stair_layer_id = stair_layer.id
          @stair_layers = stair_layer.canteen.stair_layers

          #上级
          @region_id = stair_layer.canteen.region_id

          @canteens = stair_layer.canteen.region.canteens
          @canteen_id = stair_layer.canteen_id
        elsif granted_id == GRANTED[:canteen]
          canteen = Canteen.find(@canteen_worker.reference_id)
          #下一级
          @stair_layers = canteen.stair_layers

          #自己
          @canteen_id = canteen.id
          @canteens = canteen.region.canteens

          #上一级
          @region_id = canteen.region_id
        elsif granted_id == GRANTED[:region]
          @region_id = @canteen_worker.reference_id
        end
        return_json(format, 0, (render_as_string 'admin/canteen_worker/edit.html.erb', 'edit_modal.html.erb'))
      end
    end
  end

  def region_show
    @regions = Region.all
    respond_to do |format|
      return_json(format, 0, (render_as_string 'admin/region/show.html.erb'))
    end
  end

  def region_add
    if request.request_method =~ /post/i
      #获取区域并创建
      params_region =  params[:region]
      names = Set.new(params_region[:name].gsub(/\s+/, '').split(SPLITTER))
      if names.length > 0
        @regions = []
        names.each do |name|
          params_region[:name] = name
          begin
            temp_region = Region.create!(params_region)
            @regions.append(temp_region)
          rescue => e
            append_errors_msg(e.record)
          end
        end
        if flush_length > 0
          @regions.each do |region|
            append_msg(:success, "(#{region.name})区域名添加成功")
          end
        end
      else
        append_msg(:danger, '区域名不能为空')
      end
      respond_to do |format|
        render_template_edit_js(format, 'admin/region/edit.js.erb')
      end
    else
      @region = Region.new
      respond_to do |format|
        return_json(format, 0, (render_as_string 'admin/region/edit.html.erb', 'edit_modal.html.erb'))
      end
    end
  end

  def region_delete
    delete(Region, :region)
  end

  def region_edit
    if request.request_method =~ /post/i
      @region = Region.find(params[:id])
      if @region.name != params[:region][:name].strip
        unless @region.update(params[:region])
          append_errors_msg(@region)
        end
      else
        append_msg(:info, '未修改区域名')
      end
      respond_to do |format|
        render_template_edit_js(format, 'admin/region/edit.js.erb')
      end
    else
      @region = Region.find(params[:id])
      respond_to do |format|
        return_json(format, 0, (render_as_string 'admin/region/edit.html.erb', 'edit_modal.html.erb'))
      end
    end
  end

  def stair_layer_show
    @stair_layers = StairLayer.all
    respond_to do |format|
      return_json(format, 0, (render_as_string 'admin/stair_layer/show.html.erb'))
    end
  end

  def stair_layer_add
    if request.request_method =~ /post/i
      #获取区域并创建
      if params[:region_id].blank? #验证区域
        append_msg(:danger, '未选择区域')
      end

      params_stair_layer = params[:stair_layer]
      if params_stair_layer[:canteen_id].blank? #验证食堂,防止每个楼层号都出现验证消息
        append_msg(:danger, '未选择食堂')
      end

      if flush_length == 0
        layers = Set.new(params_stair_layer[:layer].gsub(/\s+/, '').split(SPLITTER))
        if layers.length > 0
          @stair_layers = []
          layers.each do |layer|
            params_stair_layer[:layer] = layer
            begin
              temp_stair_layer = StairLayer.create!(params_stair_layer)
              @stair_layers.append(temp_stair_layer)
            rescue => e
              append_errors_msg(e.record)
            end
          end

          if flush_length > 0
            @stair_layers.each do |stair_layer|
              append_msg(:success, "(#{stair_layer.layer})楼层添加成功")
            end
          end
        else
          append_msg(:danger, '楼层号不能为空')
        end
      end
      respond_to do |format|
        render_template_edit_js(format, 'admin/stair_layer/edit.js.erb')
      end
    else
      respond_to do |format|
        if Canteen.count > 0
          @stair_layer = StairLayer.new
          return_json(format, 0, (render_as_string 'admin/stair_layer/edit.html.erb', 'edit_modal.html.erb'))
        else
          append_msg(:warning, '请先创建食堂,在添加楼层号')
          return_json(format, 1, (render_as_string 'template/bs_alert.html.erb'))
        end
      end
    end
  end

  def stair_layer_delete
    delete(StairLayer, :stair_layer)
  end

  def stair_layer_edit
    if request.request_method =~ /post/i
      @stair_layer = StairLayer.find(params[:id])
      unless @stair_layer.update(params[:stair_layer])
        append_errors_msg(@stair_layer)
      end
      respond_to do |format|
        render_template_edit_js(format, 'admin/stair_layer/edit.js.erb')
      end
    else
      @stair_layer = StairLayer.find(params[:id])
      respond_to do |format|
        return_json(format, 0, (render_as_string 'admin/stair_layer/edit.html.erb', 'edit_modal.html.erb'))
      end
    end
  end

  #信息修改
  def modify_password
    if request.request_method =~ /post/i
      #验证密码是否修改
      old_password = params[:old_password]
      new_password = params[:new_password]
      confirm_password = params[:confirm_password]
      if old_password.blank? && new_password.blank? && confirm_password.blank?
        append_msg(:info, '未填写任何信息')
      else
        @canteen_worker = CanteenWorker.find(get_user_id)
        if new_password != confirm_password
          append_msg(:danger, '新密码和确认密码不匹配')
        elsif new_password == old_password
          append_msg(:danger, '新密码和旧密码相同')
        elsif @canteen_worker.password != old_password
          append_msg(:danger, '旧密码不匹配')
        else
          if @canteen_worker.update({password: new_password})#更新密码
            append_msg(:success, '密码修改成功')
          else
            append_errors_msg(@canteen_worker)
          end
        end
      end
      respond_to do |format|
        format.js {render partial: 'template/message_notice.js.erb', :layout => false}
      end
    else
      respond_to do |format|
        @canteen_worker = CanteenWorker.find(get_user_id)
        return_json(format, 0, (render_as_string 'admin/info/modify_password.html.erb', 'layouts/user_modify.html.erb'))
      end
    end
  end

  def modify_basic_info
    if request.request_method =~ /post/i
      @canteen_worker = CanteenWorker.find(get_user_id)
      #修改姓名
      account = params[:canteen_worker][:account]
      name = params[:canteen_worker][:name]
      gender = params[:canteen_worker][:gender]

      #修改登陆账号
      if @canteen_worker.account != account
        if @canteen_worker.update({account: account})
          append_msg(:success, '登录账号修改成功')
          session_set_user(@canteen_worker)
        else
          append_errors_msg(@canteen_worker)
        end
        # else
        #   append_msg(:info, '未修改姓名')
      end

      #修改姓名
      if @canteen_worker.name != name
        if @canteen_worker.update({name: name})
          append_msg(:success, '姓名修改成功')
          @modify_name = @canteen_worker.name
          session_set_user(@canteen_worker)
        else
          append_errors_msg(@canteen_worker)
        end
      # else
      #   append_msg(:info, '未修改姓名')
      end

      #修改性别
      if @canteen_worker.gender.to_s != gender
        if @canteen_worker.update({gender: gender})
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
        @canteen_worker = CanteenWorker.find(get_user_id)
        return_json(format, 0, (render_as_string 'admin/info/modify_basic_info.html.erb', 'layouts/user_modify.html.erb'))
      end
    end
  end

  def modify_photo
    if request.request_method =~ /post/i
      if params[:canteen_worker].blank?
        append_msg(:info, '未选择头像')
      else
        @canteen_worker = CanteenWorker.find(get_user_id)
        if @canteen_worker.update({ photo: params[:canteen_worker][:photo]})
          append_msg(:success, '头像修改成功')
          respond_to do |format|
            format.html { render text: { status: 0, result: { content: render_as_string('admin/info/modify_photo.html.erb', 'layouts/user_modify.html.erb'), message: render_as_string('template/bs_alert.html.erb')}}.to_json }
          end
          return
        else
          append_errors_msg(@canteen_worker)
        end
      end
      respond_to do |format|
        format.html { render text: { status: 0, result: render_as_string('template/bs_alert.html.erb')}.to_json }
      end
    else
      @canteen_worker = CanteenWorker.find(get_user_id)
      respond_to do |format|
        return_json(format, 0, (render_as_string 'admin/info/modify_photo.html.erb', 'layouts/user_modify.html.erb'))
      end
    end
  end
  
  
  def dynamic_select_between_region_and_canteen #区域和食堂级联
    @canteens = Region.find(params[:id]).canteens
    respond_to do |format|
      return_json(format, 0, @canteens.as_json(only: [:id, :name]))
    end
  end

  #食堂和楼层号级联
  def dynamic_select_between_canteen_and_stair_layer
    @stair_layers = Canteen.find(params[:id]).stair_layers
    respond_to do |format|
      format.json { render 'admin/canteen_window/dynamic_select_canteen_stair_layer.json.jbuilder' }
    end
  end

  #楼层号和食堂窗口级联
  def dynamic_select_between_stair_layer_and_canteen_window
    @canteen_windows = StairLayer.find(params[:id]).canteen_windows
    respond_to do |format|
      return_json(format, 0, @canteen_windows.as_json(only: [:id, :name]))
    end
  end

  def delete(model, table_name=nil)
    respond_to do |format|
      ids = params[:id].split(SPLITTER)
      #先清除关联的权限
      if table_name
        begin
          CanteenWorker.transaction do
            CanteenWorker.where(granted_id: GRANTED[table_name], reference_id: ids).update_all(granted_id: GRANTED[:none], reference_id: -1)
          end
        rescue
          return_json(format, 1, '相关联的食堂工作人员权限解除失败,导致删除失败')
          return
        end
      end

      begin
        model.transaction do #在删除食堂结构
          model.destroy(ids)
        end
        return_json(format, 0, '删除成功')
      rescue
        return_json(format, 1, '记录被引用导致删除失败')
      end
    end
  end
end