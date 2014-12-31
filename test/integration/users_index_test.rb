require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  # log in, visit the index path, verify the first page of users is present
  # confirm that pagination is present on the page
  test "should confirm pagination present " do
    # login as user - see setup
    log_in_as(@user)
    # GET users_path
    get users_path
    # should render 'users/index' template
    assert_template 'users/index'
    # select pagination div 
    assert_select 'div.pagination'
    # select each user on paginate page
    User.paginate(page: 1).each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
    end
  end
end
