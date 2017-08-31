require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:dummy)
  end

  test "microposts interface" do
    log_in_as(@user)
    get root_path
    assert_select "div.pagination"

    # Invalid post submission.
    assert_no_difference "Micropost.count" do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_select "div#error_explanation"

    # Valid post submission.
    assert_difference "Micropost.count" do
      post microposts_path, params: { micropost: { content: "Valid post :)" } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_select "div.alert.alert-success"

    # Delete a post.
    assert_select "a", text: "Delete"
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference "Micropost.count", -1 do
      delete micropost_path(first_micropost)
    end

    # No delete links on second user page.
    get user_path(users(:lana))
    assert_select "a", text: "Delete", count: 0
  end

  test "sidebar" do
    # When the user is not logged in.
    get root_path
    assert_select "a", text: "Sign up now!"

    # When the user is logged in.
    log_in_as(@user)
    get root_path

    assert_select "section.user_info"
    assert_select "section.micropost_form"

    microposts_count = @user.microposts.paginate(page: 1).count
    assert_select "section.user_info>span",
      text: "#{microposts_count} microposts"

    # User with no microposts.
    malory = users(:malory)
    log_in_as(malory)
    get root_path
    assert_select "section.user_info>span", text: "0 microposts"

    malory.microposts.create!(content: "Malory's micropost!")
    get root_path
    assert_match "1 micropost", response.body
  end
end
