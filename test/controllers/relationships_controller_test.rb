require 'test_helper'

class RelationshipsControllerTest < ActionController::TestCase

  # attempts to access actions in the Relationships create action require a logged-in user
  # and thus get redirected to the login page, while also not changing the Relationship count
  test "create should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      post :create
    end
    assert_redirected_to login_url
  end

  # attempts to access actions in the Relationships create action require a logged-in user
  # and thus get redirected to the login page, while also not changing the Relationship count
  test "destroy should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      delete :destroy, id: relationships(:one)
    end
    assert_redirected_to login_url
  end
end