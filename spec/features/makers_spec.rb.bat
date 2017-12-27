require "rails_helper"
require_relative '../maker_login/maker_login'
include MakerLogin
feature 'user as admin login in home page', :type => :feature do
  background 'enter home page, then click login link' do
    page.driver.browser.manage.window.maximize
    visit maker_index_path#进入到首页
    click_link 'maker_user_login'#获取登陆弹出框
  end

  let(:canteen_worker) {
    FactoryGirl.build(:canteen_worker)
  }
  context 'as a user' do
    # scenario 'is invalid without account and password', js: true do
    #   login_test(FactoryGirl.build(:canteen_worker, :account => nil, :password => nil))
    #   expect(page).to have_css 'div.alert'
    # end
    #
    # scenario 'is invalid without account', js: true do
    #   login_test(FactoryGirl.build(:canteen_worker, :account => nil))
    #   expect(page).to have_css 'div.alert'
    # end
    #
    # scenario 'is invalid without password', js: true do
    #   login_test(FactoryGirl.build(:canteen_worker, :password => nil))
    #   expect(page).to have_css 'div.alert'
    # end
    #
    # scenario 'is invalid account', js: true do
    #   login_test(FactoryGirl.build(:canteen_worker, :account => 'none'))
    #   expect(page).to have_css 'div.alert'
    # end
    #
    # scenario 'is invalid password', js: true do
    #   login_test(FactoryGirl.build(:canteen_worker, :password => 'none'))
    #   expect(page).to have_css 'div.alert'
    # end
    scenario 'is valid user and redirect to maker_user_admin_path', js: true do
      login_test(canteen_worker)
      expect(current_path).to eq maker_user_admin_path
      expect(page).to have_content "#{canteen_worker.name}"
    end
  end

  feature 'manage canteen structure', :type => :feature do
    background 'login in system' do
      login_test(canteen_worker)#进行登陆
    end
    feature 'canteen region manage' , :type => :feature do

      background 'click link contains 区域', js: true do
        find('a[data-method="region_show"]').click
      end

      scenario 'view regions information', js:true do
        find('a[data-method="region_show"]').click
        expect(page).to have_css('ol.breadcrumb li span', :text => '区域')
      end

      scenario 'add region', js: true do
        find('button[name="add"]').click

      end

    end

  end
end

def print_page()
  print page.html
end