require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
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

  test "should redirect when logged in as a wrong user" do
    # login as other user - see fixtures
    log_in_as(@other_user)
    # GET edit template for user with user id mentioned 
    get :edit, id: @user
    # test that other user sees an empty flash
    assert flash.empty?
    # test that other user is redirected to root_url
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    # login as other user - see fixtures
    log_in_as(@other_user)
    # send a patch request to the update action
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    # the other user should not see a flash
    assert flash.empty?
    # the other user is redirect to root_url
    assert_redirected_to root_url
  end
end
