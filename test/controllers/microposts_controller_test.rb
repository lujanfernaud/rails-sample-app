require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @micropost = microposts(:orange)
  end

  test "should redirect create when not logged in" do
    assert_no_difference "Micropost.count" do
      post microposts_path, params: { micropost: { content: "Test." } }
    end

    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference "Micropost.count" do
      delete micropost_path(@micropost)
    end

    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong micropost" do
    lana = users(:lana)
    post = microposts(:ants)

    log_in_as lana

    assert_no_difference "Micropost.count" do
      delete micropost_path(post)
    end

    assert_redirected_to root_url
  end
end
