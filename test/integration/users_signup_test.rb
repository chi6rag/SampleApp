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
end