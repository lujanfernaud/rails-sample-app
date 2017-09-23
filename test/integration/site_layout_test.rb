require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:archer)
  end

  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", login_path

    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end

  test "layout links when logged in" do
    log_in_as(@user)
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", logout_path

    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end

  test "contact page title" do
    get contact_path
    assert_select "title", full_title("Contact")
  end

  test "signup page title" do
    get signup_path
    assert_select "title", full_title("Sign up")
  end
end
