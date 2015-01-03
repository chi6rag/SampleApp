require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end

  test "micropost interface" do
    # log in
    # check the micropost pagination
    # make an invalid submission
    # make a valid submission
    # delete a post
    # visit a second user’s page to make sure there are no “delete” links
    
    log_in_as(@user)  
    get home_path
    assert_select 'div.pagination'
    # Invalid Submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, micropost: { content: '' }
    end
    assert_select 'div#error_explanation'
    # Valid Submission
    assert_difference 'Micropost.count', 1 do
      post microposts_path, micropost: { content: 'lorem' }
    end
    assert_redirected_to root_url
    follow_redirect!
    # Delete a post
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # Visiting a different user
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end
end
