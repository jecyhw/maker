require "rails_helper"
require_relative '../maker_login/maker_login'
include MakerLogin
feature 'user as admin login in home page', :type => :feature do
  background 'enter home page, then click login link' do
    page.driver.browser.manage.window.maximize
    visit maker_index_path#进入到首页
  end

  context 'as a admin' do
    let(:canteen_worker) {
      FactoryGirl.build(:canteen_worker)
    }
    scenario 'is valid user and redirect to maker_user_admin_path', js: true do
      click_link 'maker_user_login'#获取登陆弹出框
      sleep(2)
      login_test(canteen_worker)
      sleep(3)
      expect(current_path).to eq maker_user_admin_path
      expect(page).to have_content "#{canteen_worker.name}"

      ####################################################
      #区域管理
      ####################################################
      #显示区域
      find('a[data-method="region_show"]').click
      sleep(2)
      #添加区域
      find('button[name="add"]').click
      fill_in 'region[name]', with: FactoryGirl.build(:region).name
      sleep(2)
      find('button[type="submit"]').click
      sleep(3)

      #修改区域
      all(:css, 'button[name="edit"]').first.click
      fill_in 'region[name]', with: '南区'
      sleep(2)
      find('button[type="submit"]').click
      sleep(3)

      #删除区域
      all(:css, 'table button[name="delete"]').first.click
      sleep(3)
      find('button[name="sure"]').click
      sleep(3)

      ####################################################
      #食堂
      ####################################################
      #显示食堂
      find('a[data-method="canteen_show"]').click
      sleep(2)
      #添加食堂
      find('button[name="add"]').click
      #select('西区', :from => 'canteen_region_id')
      find('#canteen_region_id option', :text => '西区').select_option
      fill_in 'canteen[name]', with: '一食堂'
      page.execute_script('$("#canteen_photo").removeClass("hide")')
      page.attach_file('canteen_photo', File.absolute_path('public/canteen1.png'))
      page.execute_script('$("#canteen_photo").addClass("hide")')
      sleep(2)
      find('button[type="submit"]').click
      sleep(4)

      find('button[name="add"]').click
      #select('西区', :from => 'canteen_region_id')
      find('#canteen_region_id option', :text => '西区').select_option
      fill_in 'canteen[name]', with: '二食堂'
      page.execute_script('$("#canteen_photo").removeClass("hide")')
      page.attach_file('canteen_photo', File.absolute_path('public/canteen2.png'))
      page.execute_script('$("#canteen_photo").addClass("hide")')
      sleep(2)
      find('button[type="submit"]').click
      sleep(4)

      find('button[name="add"]').click
      #select('西区', :from => 'canteen_region_id')
      find('#canteen_region_id option', :text => '东区').select_option
      fill_in 'canteen[name]', with: '三食堂'
      page.execute_script('$("#canteen_photo").removeClass("hide")')
      page.attach_file('canteen_photo', File.absolute_path('public/canteen3.png'))
      page.execute_script('$("#canteen_photo").addClass("hide")')
      sleep(2)
      find('button[type="submit"]').click
      sleep(4)

      ###################################################
      #楼层号
      ###################################################
      #显示
      find('a[data-method="stair_layer_show"]').click
      sleep(2)

      #添加
      find('button[name="add"]').click
      find('#region_id option', :text => '西区').select_option
      sleep(1)
      find('#stair_layer_canteen_id option', :text => '一食堂').select_option
      fill_in 'stair_layer[layer]', with: '1|2|3'
      sleep(2)
      find('button[type="submit"]').click
      sleep(3)

      ###################################################
      #食堂窗口
      ###################################################
      #显示
      find('a[data-method="canteen_window_show"]').click
      sleep(2)
      #添加
      find('button[name="add"]').click
      find('#region_id option', :text => '西区').select_option
      sleep(1)
      find('#canteen_id option', :text => '一食堂').select_option
      sleep(1)
      find('#canteen_window_stair_layer_id option', :text => '1').select_option
      sleep(1)
      fill_in 'canteen_window[name]', with: '一窗口|二窗口|三窗口|四窗口|五窗口'
      sleep(2)
      find('button[type="submit"]').click
      sleep(3)


      ###################################################
      #食堂工作人员窗口
      ###################################################
      #显示
      find('a[data-method="canteen_worker_show"]').click
      sleep(2)
      #添加
      find('button[name="add"]').click
      sleep(2)
      find('form button.close').click
      sleep(1)
      fill_in 'canteen_worker[account]', with: '2016maker'
      fill_in 'canteen_worker[name]', with: '张三'
      find('#canteen_worker_gender option', :text => '男').select_option
      sleep(1)
      find('.padding-left-fixed button[type="button"]').click
      sleep(1)
      find('#region option', :text => '西区').select_option
      sleep(1)
      find('#canteen option', :text => '一食堂').select_option
      sleep(1)
      find('#stair_layer option', :text => '1').select_option
      sleep(1)
      find('#canteen_window option', :text => '一窗口').select_option
      sleep(2)
      find('button[type="submit"]').click
      sleep(3)

      ###################################################
      #个人资料
      ###################################################
      #修改头像
      find('a[data-method="modify_photo"]').click
      sleep(2)
      page.execute_script('$("#canteen_worker_photo").removeClass("hide")')
      page.attach_file('canteen_worker_photo', File.absolute_path('public/canteen1.png'))
      page.execute_script('$("#canteen_worker_photo").addClass("hide")')
      sleep(2)
      find('button[type="submit"]').click
      sleep(4)

      #修改密码
      find('a[data-method="modify_password"]').click
      sleep(2)

      fill_in 'old_password', with: "#{canteen_worker.password}"
      fill_in 'new_password', with: '1a2s3d'
      fill_in 'confirm_password', with: '1a2s3d'
      sleep(2)
      find('button[type="submit"]').click
      sleep(3)

      #退出
      find('#maker_user_logout').click
      sleep(2)

      #注册
      find('#maker_user_register').click
      sleep(2)

      fill_in 'student[email]', with: 'yanghuiwei15@mails.ucas.ac.cn'
      sleep(1)
      find('#goto').click
      sleep(1)
      find('button[type="submit"]').click
      sleep(10)

    end
  end



end

def print_page()
  print page.html
end