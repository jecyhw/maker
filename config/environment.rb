# Load the Rails application.
require File.expand_path('../application', __FILE__)
USER_TYPE = {:admin => 'admin', :student => 'student', :canteen_worker => 'canteen_worker'}
GENDER = {:'保密' => 0, :'男' => 1, :'女' => 2 }
OPERATE_TYPE = {
    :add => '添加',
    :edit => '修改',
    :delete => '删除',
    :show => '显示',
    :query => '查询'
}
SPLITTER = '|'

#GRANTED = { all: 0, region: 1, canteen: 2, stair_layer: 3, canteen_window: 4 }
GRANTED = {}

WEB_NAME = '校园微餐厅'

UCAS_MAIL_ADDRESS = 'https://mail.cstnet.cn/'
# Initialize the Rails application.
Rails.application.initialize!
begin
    Granted.all.order(:grade).each do |granted|
        # table_name = granted.table_name.to_sym
        # grade = granted.grade.to_s.to_sym
        # GRANTED[grade] = table_name
        # GRANTED[table_name] = grade
        GRANTED[granted.table_name.to_sym] = granted.id
    end
rescue => e
    puts e.message
end

