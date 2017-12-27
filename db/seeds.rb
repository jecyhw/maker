# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
CanteenWorker.delete_all
Granted.delete_all
Granted.create([{grade: -1, table_name: 'none', alias: '未分配权限'},
                         {grade: 0, table_name: 'all', alias: '所有'},
                         {grade: 1, table_name: 'region', alias: '区域'},
                         {grade: 2, table_name: 'canteen', alias: '食堂'},
                         {grade: 3, table_name: 'stair_layer', alias: '楼层'},
                         {grade: 4, table_name: 'canteen_window', alias: '窗口'}])
CanteenWorker.create({account: '41112190', name: '杨慧伟', granted_id: Granted.find_by_grade(0).id})