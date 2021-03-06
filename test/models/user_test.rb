require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Test", email: "test@testooo.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = " "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = " "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 255 + "@test.com"
    assert_not @user.valid?
  end

  test "email should be a valid email" do
    valid_addresses = %w[alice@foo.com alan@bar.jp emerald@baz.co.uk]

    valid_addresses.each do |email|
      @user.email = email
      assert @user.valid?, "#{email.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org
                           user.name@example. foo@bar_baz.com foo@bar+baz.com]

    invalid_addresses.each do |email|
      @user.email = email
      assert_not @user.valid?, "#{email.inspect} should be invalid"
    end
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email should be downcase" do
    @user.email = "TEST@tEEsToOoO.Com"
    @user.save
    assert @user.email == @user.email.downcase
  end

  test "password shoul be present (non blank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password shoul have a minimum length" do
    @user.password = @user.password_confirmation = "abcd"
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, "")
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Test.")

    assert_difference "Micropost.count", -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    dummy  = users(:dummy)
    archer = users(:archer)

    assert_not dummy.following?(archer)
    dummy.follow(archer)
    assert dummy.following?(archer)
    assert archer.followed_by?(dummy)
    dummy.unfollow(archer)
    assert_not dummy.following?(archer)
    assert_not archer.followed_by?(dummy)
  end

  test "feed should have the right posts" do
    dummy  = users(:dummy)
    lana   = users(:lana)
    archer = users(:archer)

    # Posts from followed user.
    lana.microposts.each do |post_following|
      assert dummy.feed.include?(post_following)
    end

    # Posts from self.
    dummy.microposts.each do |post_self|
      assert dummy.feed.include?(post_self)
    end

    # Posts from unfollowed user.
    archer.microposts.each do |post_unfollowed|
      assert_not dummy.feed.include?(post_unfollowed)
    end
  end
end
