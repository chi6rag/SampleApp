require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # INVALID EMAIL
      # post to password_resets_path with a password_reset has that contains a blank email
      post password_resets_path, password_reset: { email: '' }
      # assume flash message not empty
      assert_not flash.empty?
      assert_template 'password_resets/new'
    # VALID EMAIL
      # post to password_resets_path with a password_reset has that contains a valid email
      post password_resets_path, password_reset: { email: @user.email }
      # the old reset digest should not be equal to the new reset digest 
      # OLD reset_digest was NIL
      # check for email sent
      assert_equal 1, ActionMailer::Base.deliveries.size
      assert_not flash.empty?
      assert_redirected_to root_url
    # ----------- PASSWORD RESET FORM----------- #
        user = assigns(:user)
      # WRONG EMAIL
        get edit_password_reset_path(user.reset_token, email: '')
        assert_redirected_to root_url
      # INACTIVE USER
        user.toggle!(:activated)
        get edit_password_reset_path(user.reset_token, email: user.email)
        assert_redirected_to root_url
        user.toggle!(:activated)
      # RIGHT EMAIL WRONG TOKEN
        get edit_password_reset_path('wrong token', email: user.email)
        assert_redirected_to root_url
      # RIGHT EMAIL RIGHT TOKEN
        get edit_password_reset_path(user.reset_token, email: user.email)
        assert_template 'password_resets/edit'
        assert_select "input[name=email][type=hidden][value=?]", user.email
      # INVALID PASSWORD AND CONFIRMATION
        patch password_reset_path(user.reset_token),
          email: user.email,
          user: {
            password: 'foobar',
            password_confirmation: 'ksdfkasndfk'
          }
        assert_select "div#error_explanation"
      # BLANK PASSWORD and CONFIRMATION
        patch password_reset_path(user.reset_token),
          email: user.email,
          user: {
            password: '      ',
            password_confirmation: '      '
          }
        assert_not flash.empty?
        assert_template 'password_resets/edit'
      # VALID PASSWORD AND CONFIRMATION
        patch password_reset_path(user.reset_token),
          email: user.email,
          user: {
            password: 'foobar',
            password_confirmation: 'foobar'
          }
        assert is_logged_in?
        assert_not flash.empty?
        assert_redirected_to user
  end
end
