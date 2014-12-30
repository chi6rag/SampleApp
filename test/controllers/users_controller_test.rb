require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  def setup
    @user = users(:michael)
  end

  test "should get new" do
    get :new
    assert_response :success
  end


  test "should redirect edit when not logged in" do
    # GET edit page for user with user id of @user
    get :edit, id: @user
    # flash is not empty
    assert_not flash.empty?
    # redirected to login url
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    # send a petch request to specified user with user params 
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    # flash is not empty
    assert_not flash.empty?
    # redirected to login url
    assert_redirected_to login_url
  end
end
