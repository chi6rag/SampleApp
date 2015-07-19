require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other = users(:archer)
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

  # should follow a user in a standard way
  # posting to relationships path should increase the following of user
  test "should follow a user in a standard way" do
    assert_difference '@user.following.count', 1 do
      post relationships_path, followed_id: @other.id
    end
  end

  test "should follow a user with AJAX" do
    assert_difference '@user.following.count' do
      post relationships_path, followed_id: @other.id
    end
  end

  test "should unfollow a user the standard way" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test "should unfollow a user the AJAXified way" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      xhr :delete, relationship_path(relationship)
    end
  end
end


