require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase
  
  def setup
    @micropost = microposts(:orange)
  end

  # should redirect create when not logged in
  # if a non logged in user tries to create a micropost, he should be redirected to login_url
  # check the number of microposts before and after creating a micropost as a non logged in user
  # shold redirect to login_url 
  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do
      post :create, micropost: { content: "Lorem Ipsum!" }
    end
    assert_redirected_to login_url
  end

  # should redirect destroy when not logged in
  # if a non logged in user tries to destroy a micropost, he should be redirected to login_url
  # check the number of microposts before and after destroying a micropost as a non logged in user
  # shold redirect to login_url 
  test "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do
      delete :destroy, id: @micropost
    end
    assert_redirected_to login_url
  end
end
