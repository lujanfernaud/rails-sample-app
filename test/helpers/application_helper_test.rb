require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title, "Kwakker"
    assert_equal full_title("About"),
      "About | Kwakker"
  end
end
