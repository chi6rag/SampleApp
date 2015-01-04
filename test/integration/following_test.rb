require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    log_in_as(@user)
  end

  test "following page" do
    # get following page for @user
    # since :michael has relationship fixtures defined already, following should not be empty
    # match following count
    # for each following, check profile link 
    get following_user_path(@user)
    assert_not @user.following.empty?
    assert @user.following.count.to_s, response.body
    @user.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "followers page" do
    # get followers page for @user
    # since :michael has relationship fixtures defined already, followers should not be empty
    # match followers count
    # for each follower, check profile link 
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    assert @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end
end
