require 'test_helper'
  
class UsersSignupTest < ActionDispatch::IntegrationTest
  
  # purpose: verify that clicking the signup button results in
  # not creating a new user when the submitted information is invalid
  test "invalid signup information" do
      # store previous count of Users in User model
      # submit the form with invalid data
      # check if the new Users count in User model is equal to the previous one
      # if yes, invalid data in signup form does not make a new user
      # else it does
      get signup_path
      
      # my way - straight path
      # before_count = User.count
      # post users_path, user: {
      #   name: "",
      #   email: 'user@invalid',
      #   password: "foo",
      #   password_confirmation: 'bar'
      # }
      # after_count = User.count
      # assert_equal before_count, after_count

      # ----- improvised way -----
      assert_no_difference 'User.count' do 
        post users_path, user: {
          name: "",
          email: "user@invalid",
          password: "foo",
          password_confirmation: "bar"
        }
      end
  end

  test "valid signup information" do
    get signup_path
    # bruteforce method
    # before_count = User.count
    # post users_path, user: {
    #   name: "Chirag Aggarwal",
    #   email: "chi6rag@gmail.com",
    #   password: "123456789a",
    #   password_confirmation: "123456789a"
    # }
    # after_count = User.count
    # assert_not_equal before_count, after_count
    
    # improvised method
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: {
        name: "Chirag Aggarwal",
        email: "chi6rag@gmail.com",
        password: "123456789a",
        password_confirmation: "123456789a"
      }
    end

    assert_template 'users/show'
    assert is_logged_in?
  end
end