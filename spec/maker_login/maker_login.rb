module MakerLogin
  def login_test(user)
    fill_login_form(user)
    sleep(2)
    find('button[type="submit"]').click
  end

  def fill_login_form(user)
    fill_in 'account', with: user.account
    fill_in 'password', with: user.password
  end
end